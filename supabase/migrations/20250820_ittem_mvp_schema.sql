-- Ittem MVP Database Schema Migration
-- Execute in Supabase SQL Editor

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- Create ENUM types
CREATE TYPE item_status AS ENUM ('available', 'rented', 'archived');
CREATE TYPE rental_status AS ENUM ('requested', 'accepted', 'rejected', 'paid', 'in_use', 'completed', 'cancelled');
CREATE TYPE payment_status AS ENUM ('pending', 'paid', 'refunded', 'failed');

-- Profiles table (extends auth.users)
CREATE TABLE profiles (
    id UUID REFERENCES auth.users PRIMARY KEY,
    nickname VARCHAR(50) NOT NULL,
    photo_url TEXT,
    rating DECIMAL(3,2) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Items table with geographic point
CREATE TABLE items (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    owner_id UUID REFERENCES profiles(id) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    price_per_day INTEGER NOT NULL CHECK (price_per_day > 0),
    deposit INTEGER DEFAULT 0 CHECK (deposit >= 0),
    lat DECIMAL(10, 8) NOT NULL,
    lng DECIMAL(11, 8) NOT NULL,
    geom GEOGRAPHY(POINT, 4326) GENERATED ALWAYS AS (ST_MakePoint(lng, lat)::geography) STORED,
    photos JSONB DEFAULT '[]'::jsonb,
    status item_status DEFAULT 'available',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Rentals table
CREATE TABLE rentals (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    item_id UUID REFERENCES items(id) NOT NULL,
    renter_id UUID REFERENCES profiles(id) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status rental_status DEFAULT 'requested',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT valid_rental_period CHECK (end_date >= start_date)
);

-- Threads table for chat conversations
CREATE TABLE threads (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    item_id UUID REFERENCES items(id) NOT NULL,
    buyer_id UUID REFERENCES profiles(id) NOT NULL,
    seller_id UUID REFERENCES profiles(id) NOT NULL,
    last_message_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(item_id, buyer_id, seller_id)
);

-- Messages table
CREATE TABLE messages (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    thread_id UUID REFERENCES threads(id) NOT NULL,
    sender_id UUID REFERENCES profiles(id) NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Payments table for PortOne integration
CREATE TABLE payments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    rental_id UUID REFERENCES rentals(id) NOT NULL,
    imp_uid VARCHAR(100) UNIQUE, -- PortOne transaction ID
    merchant_uid VARCHAR(100) UNIQUE NOT NULL, -- Our transaction ID
    amount INTEGER NOT NULL CHECK (amount > 0),
    status payment_status DEFAULT 'pending',
    raw JSONB, -- Store raw PortOne response
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX idx_items_geom ON items USING GIST (geom);
CREATE INDEX idx_items_status ON items(status);
CREATE INDEX idx_items_owner_id ON items(owner_id);
CREATE INDEX idx_items_created_at ON items(created_at DESC);

CREATE INDEX idx_rentals_item_id ON rentals(item_id);
CREATE INDEX idx_rentals_renter_id ON rentals(renter_id);
CREATE INDEX idx_rentals_status ON rentals(status);

CREATE INDEX idx_messages_thread_id ON messages(thread_id);
CREATE INDEX idx_messages_created_at ON messages(created_at DESC);

CREATE INDEX idx_threads_item_id ON threads(item_id);
CREATE INDEX idx_threads_buyer_id ON threads(buyer_id);
CREATE INDEX idx_threads_seller_id ON threads(seller_id);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE items ENABLE ROW LEVEL SECURITY;
ALTER TABLE rentals ENABLE ROW LEVEL SECURITY;
ALTER TABLE threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

-- RLS Policies for profiles
CREATE POLICY "Users can select own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- RLS Policies for items  
CREATE POLICY "Anyone can select available items" ON items FOR SELECT USING (true);
CREATE POLICY "Users can insert own items" ON items FOR INSERT WITH CHECK (auth.uid() = owner_id);
CREATE POLICY "Users can update own items" ON items FOR UPDATE USING (auth.uid() = owner_id);
CREATE POLICY "Users can delete own items" ON items FOR DELETE USING (auth.uid() = owner_id);

-- RLS Policies for rentals
CREATE POLICY "Users can select own rentals" ON rentals FOR SELECT USING (
    auth.uid() = renter_id OR 
    auth.uid() = (SELECT owner_id FROM items WHERE id = item_id)
);
CREATE POLICY "Renters can insert requests" ON rentals FOR INSERT WITH CHECK (auth.uid() = renter_id);
CREATE POLICY "Owners and renters can update rentals" ON rentals FOR UPDATE USING (
    auth.uid() = renter_id OR 
    auth.uid() = (SELECT owner_id FROM items WHERE id = item_id)
);

-- RLS Policies for threads
CREATE POLICY "Thread participants can select" ON threads FOR SELECT USING (
    auth.uid() = buyer_id OR auth.uid() = seller_id
);
CREATE POLICY "Thread participants can insert" ON threads FOR INSERT WITH CHECK (
    auth.uid() = buyer_id OR auth.uid() = seller_id
);

-- RLS Policies for messages  
CREATE POLICY "Thread participants can select messages" ON messages FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM threads 
        WHERE id = thread_id AND (buyer_id = auth.uid() OR seller_id = auth.uid())
    )
);
CREATE POLICY "Thread participants can insert messages" ON messages FOR INSERT WITH CHECK (
    auth.uid() = sender_id AND
    EXISTS (
        SELECT 1 FROM threads 
        WHERE id = thread_id AND (buyer_id = auth.uid() OR seller_id = auth.uid())
    )
);

-- RLS Policies for payments
CREATE POLICY "Users can select own payments" ON payments FOR SELECT USING (
    auth.uid() = (SELECT renter_id FROM rentals WHERE id = rental_id)
);
CREATE POLICY "Users can insert own payments" ON payments FOR INSERT WITH CHECK (
    auth.uid() = (SELECT renter_id FROM rentals WHERE id = rental_id)
);
CREATE POLICY "Users can update own payments" ON payments FOR UPDATE USING (
    auth.uid() = (SELECT renter_id FROM rentals WHERE id = rental_id)
);

-- Function for nearby items search
CREATE OR REPLACE FUNCTION items_nearby(
    lat FLOAT8,
    lng FLOAT8, 
    meters INT DEFAULT 5000
)
RETURNS SETOF items
LANGUAGE SQL
STABLE
AS $$
    SELECT * FROM items 
    WHERE ST_DWithin(
        geom, 
        ST_MakePoint(lng, lat)::geography, 
        meters
    ) 
    AND status = 'available'
    ORDER BY ST_Distance(geom, ST_MakePoint(lng, lat)::geography)
    LIMIT 50;
$$;

-- Function to update updated_at columns
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_profiles_updated_at 
    BEFORE UPDATE ON profiles 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_items_updated_at 
    BEFORE UPDATE ON items 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_rentals_updated_at 
    BEFORE UPDATE ON rentals 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payments_updated_at 
    BEFORE UPDATE ON payments 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger to update thread last_message_at on new message
CREATE OR REPLACE FUNCTION update_thread_on_message()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE threads 
    SET last_message_at = NEW.created_at 
    WHERE id = NEW.thread_id;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_thread_on_message 
    AFTER INSERT ON messages 
    FOR EACH ROW EXECUTE FUNCTION update_thread_on_message();

-- Create storage bucket for item photos (run this in Supabase dashboard)
INSERT INTO storage.buckets (id, name, public) 
VALUES ('item-photos', 'item-photos', false)
ON CONFLICT (id) DO NOTHING;

-- Storage policy for item photos
CREATE POLICY "Users can upload item photos" ON storage.objects 
FOR INSERT WITH CHECK (
    bucket_id = 'item-photos' AND
    auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "Users can view item photos" ON storage.objects 
FOR SELECT USING (bucket_id = 'item-photos');

CREATE POLICY "Users can update own item photos" ON storage.objects 
FOR UPDATE USING (
    bucket_id = 'item-photos' AND
    auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "Users can delete own item photos" ON storage.objects 
FOR DELETE USING (
    bucket_id = 'item-photos' AND
    auth.uid()::text = (storage.foldername(name))[1]
);