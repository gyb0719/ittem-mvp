-- Ittem MVP Database Schema for Supabase
-- Execute these SQL statements in Supabase SQL Editor

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- Create custom types
CREATE TYPE rental_status AS ENUM ('pending', 'approved', 'active', 'completed', 'cancelled');
CREATE TYPE payment_status AS ENUM ('pending', 'paid', 'refunded', 'failed');

-- User Profiles Table (extends Supabase auth.users)
CREATE TABLE user_profiles (
    id UUID REFERENCES auth.users PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    location VARCHAR(255) NOT NULL,
    profile_image_url TEXT,
    rating DECIMAL(3,2) DEFAULT 0.0,
    transaction_count INTEGER DEFAULT 0,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Items Table
CREATE TABLE items (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    owner_id UUID REFERENCES user_profiles(id) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    price INTEGER NOT NULL, -- Price per day in Korean Won
    category VARCHAR(50) NOT NULL,
    location VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    image_url TEXT,
    additional_images TEXT[], -- Array of image URLs
    is_available BOOLEAN DEFAULT TRUE,
    rating DECIMAL(3,2) DEFAULT 0.0,
    review_count INTEGER DEFAULT 0,
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Item Categories (reference table)
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    icon VARCHAR(50),
    color VARCHAR(7), -- Hex color code
    display_order INTEGER DEFAULT 0
);

-- Insert default categories
INSERT INTO categories (name, icon, color, display_order) VALUES
('카메라', 'camera', '#2196F3', 1),
('스포츠', 'sports', '#4CAF50', 2),
('도구', 'build', '#FF9800', 3),
('주방용품', 'kitchen', '#F44336', 4),
('완구', 'toys', '#FFEB3B', 5),
('악기', 'music_note', '#9C27B0', 6),
('전자제품', 'devices', '#607D8B', 7),
('캠핑', 'outdoor_grill', '#795548', 8),
('기타', 'category', '#9E9E9E', 99);

-- Rental Requests Table
CREATE TABLE rental_requests (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    item_id UUID REFERENCES items(id) NOT NULL,
    renter_id UUID REFERENCES user_profiles(id) NOT NULL,
    owner_id UUID REFERENCES user_profiles(id) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    duration_days INTEGER NOT NULL,
    total_price INTEGER NOT NULL,
    status rental_status DEFAULT 'pending',
    message TEXT,
    owner_response TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    approved_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE
);

-- Chats Table
CREATE TABLE chats (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    item_id UUID REFERENCES items(id) NOT NULL,
    user1_id UUID REFERENCES user_profiles(id) NOT NULL,
    user2_id UUID REFERENCES user_profiles(id) NOT NULL,
    last_message TEXT,
    last_message_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(item_id, user1_id, user2_id)
);

-- Messages Table
CREATE TABLE messages (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    chat_id UUID REFERENCES chats(id) NOT NULL,
    sender_id UUID REFERENCES user_profiles(id) NOT NULL,
    message TEXT NOT NULL,
    message_type VARCHAR(20) DEFAULT 'text', -- 'text', 'image', 'system'
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Payments Table
CREATE TABLE payments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    rental_request_id UUID REFERENCES rental_requests(id) NOT NULL,
    payer_id UUID REFERENCES user_profiles(id) NOT NULL,
    amount INTEGER NOT NULL,
    payment_method VARCHAR(20) NOT NULL, -- 'card', 'trans', 'vbank', etc.
    status payment_status DEFAULT 'pending',
    portone_imp_uid VARCHAR(100) UNIQUE,
    portone_merchant_uid VARCHAR(100) UNIQUE,
    pg_provider VARCHAR(50),
    paid_at TIMESTAMP WITH TIME ZONE,
    cancelled_at TIMESTAMP WITH TIME ZONE,
    cancel_reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Reviews Table
CREATE TABLE reviews (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    rental_request_id UUID REFERENCES rental_requests(id) NOT NULL,
    reviewer_id UUID REFERENCES user_profiles(id) NOT NULL,
    reviewee_id UUID REFERENCES user_profiles(id) NOT NULL,
    item_id UUID REFERENCES items(id) NOT NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    title VARCHAR(200),
    comment TEXT,
    images TEXT[], -- Array of review image URLs
    is_anonymous BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(rental_request_id, reviewer_id)
);

-- Notifications Table
CREATE TABLE notifications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES user_profiles(id) NOT NULL,
    type VARCHAR(50) NOT NULL, -- 'rental_request', 'payment', 'chat', 'review', etc.
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    data JSONB, -- Additional data specific to notification type
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User Favorites Table
CREATE TABLE user_favorites (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES user_profiles(id) NOT NULL,
    item_id UUID REFERENCES items(id) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, item_id)
);

-- Create indexes for better performance
CREATE INDEX idx_items_owner_id ON items(owner_id);
CREATE INDEX idx_items_category ON items(category);
CREATE INDEX idx_items_location ON items(location);
CREATE INDEX idx_items_available ON items(is_available);
CREATE INDEX idx_items_created_at ON items(created_at);
CREATE INDEX idx_rental_requests_item_id ON rental_requests(item_id);
CREATE INDEX idx_rental_requests_renter_id ON rental_requests(renter_id);
CREATE INDEX idx_rental_requests_status ON rental_requests(status);
CREATE INDEX idx_messages_chat_id ON messages(chat_id);
CREATE INDEX idx_messages_created_at ON messages(created_at);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);

-- Enable Row Level Security (RLS)
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE items ENABLE ROW LEVEL SECURITY;
ALTER TABLE rental_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE chats ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;

-- RLS Policies for user_profiles
CREATE POLICY "Users can view own profile" ON user_profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON user_profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Anyone can view basic profile info" ON user_profiles FOR SELECT USING (true);

-- RLS Policies for items
CREATE POLICY "Anyone can view available items" ON items FOR SELECT USING (is_available = true);
CREATE POLICY "Users can create own items" ON items FOR INSERT WITH CHECK (auth.uid() = owner_id);
CREATE POLICY "Users can update own items" ON items FOR UPDATE USING (auth.uid() = owner_id);
CREATE POLICY "Users can delete own items" ON items FOR DELETE USING (auth.uid() = owner_id);

-- RLS Policies for rental_requests
CREATE POLICY "Users can view own rental requests" ON rental_requests 
    FOR SELECT USING (auth.uid() = renter_id OR auth.uid() = owner_id);
CREATE POLICY "Users can create rental requests" ON rental_requests 
    FOR INSERT WITH CHECK (auth.uid() = renter_id);
CREATE POLICY "Owners can update rental requests for their items" ON rental_requests 
    FOR UPDATE USING (auth.uid() = owner_id);

-- RLS Policies for chats
CREATE POLICY "Users can view own chats" ON chats 
    FOR SELECT USING (auth.uid() = user1_id OR auth.uid() = user2_id);
CREATE POLICY "Users can create chats" ON chats 
    FOR INSERT WITH CHECK (auth.uid() = user1_id OR auth.uid() = user2_id);

-- RLS Policies for messages
CREATE POLICY "Users can view messages in their chats" ON messages 
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM chats 
            WHERE chats.id = messages.chat_id 
            AND (chats.user1_id = auth.uid() OR chats.user2_id = auth.uid())
        )
    );
CREATE POLICY "Users can send messages" ON messages 
    FOR INSERT WITH CHECK (auth.uid() = sender_id);

-- RLS Policies for payments
CREATE POLICY "Users can view own payments" ON payments FOR SELECT USING (auth.uid() = payer_id);
CREATE POLICY "Users can create payments" ON payments FOR INSERT WITH CHECK (auth.uid() = payer_id);

-- RLS Policies for reviews
CREATE POLICY "Anyone can view reviews" ON reviews FOR SELECT USING (true);
CREATE POLICY "Users can create own reviews" ON reviews FOR INSERT WITH CHECK (auth.uid() = reviewer_id);
CREATE POLICY "Users can update own reviews" ON reviews FOR UPDATE USING (auth.uid() = reviewer_id);

-- RLS Policies for notifications
CREATE POLICY "Users can view own notifications" ON notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own notifications" ON notifications FOR UPDATE USING (auth.uid() = user_id);

-- RLS Policies for user_favorites
CREATE POLICY "Users can view own favorites" ON user_favorites FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own favorites" ON user_favorites FOR ALL USING (auth.uid() = user_id);

-- Functions and Triggers
-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add updated_at triggers
CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON user_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_items_updated_at BEFORE UPDATE ON items FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_rental_requests_updated_at BEFORE UPDATE ON rental_requests FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_chats_updated_at BEFORE UPDATE ON chats FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON reviews FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to update chat's updated_at when new message is added
CREATE OR REPLACE FUNCTION update_chat_on_new_message()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE chats 
    SET 
        updated_at = NOW(),
        last_message = NEW.message,
        last_message_at = NEW.created_at
    WHERE id = NEW.chat_id;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_chat_on_message AFTER INSERT ON messages FOR EACH ROW EXECUTE FUNCTION update_chat_on_new_message();

-- Function to update item and user ratings when review is created
CREATE OR REPLACE FUNCTION update_ratings_on_review()
RETURNS TRIGGER AS $$
BEGIN
    -- Update item rating
    UPDATE items SET 
        rating = (
            SELECT COALESCE(AVG(rating::decimal), 0) 
            FROM reviews 
            WHERE item_id = NEW.item_id
        ),
        review_count = (
            SELECT COUNT(*) 
            FROM reviews 
            WHERE item_id = NEW.item_id
        )
    WHERE id = NEW.item_id;
    
    -- Update user rating
    UPDATE user_profiles SET 
        rating = (
            SELECT COALESCE(AVG(rating::decimal), 0) 
            FROM reviews 
            WHERE reviewee_id = NEW.reviewee_id
        )
    WHERE id = NEW.reviewee_id;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_ratings_on_review AFTER INSERT ON reviews FOR EACH ROW EXECUTE FUNCTION update_ratings_on_review();