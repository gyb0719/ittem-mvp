# Supabase Setup Guide for Ittem MVP

## 1. Apply Database Migration

1. Open your Supabase project dashboard
2. Go to SQL Editor
3. Copy and paste the entire content of `supabase/migrations/20250820_ittem_mvp_schema.sql`
4. Execute the SQL script

## 2. Configure Storage

1. Go to Storage in Supabase dashboard
2. Verify `item-photos` bucket was created
3. If not created manually, create a private bucket named `item-photos`

## 3. Enable Required Extensions

The migration should automatically enable:
- `uuid-ossp` - for UUID generation
- `postgis` - for geographic queries

## 4. Test Database Setup

Run these queries to verify setup:

```sql
-- Test tables exist
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Test PostGIS extension
SELECT ST_MakePoint(127.0276, 37.4979)::geography;

-- Test nearby items function
SELECT items_nearby(37.4979, 127.0276, 1000);
```

## 5. Environment Variables

Update your `env/dev.json` and `env/prod.json` with:
- `SUPABASE_URL`: Your project URL
- `SUPABASE_ANON_KEY`: Your anon/public key

## 6. Key Features Included

- **Geographic Search**: Items can be searched by location using PostGIS
- **Row Level Security**: Users can only access their own data
- **Real-time**: Messages table supports real-time subscriptions
- **Storage**: Secure photo upload with user-specific policies
- **Payment Integration**: Ready for PortOne payment webhooks

## 7. Run Configuration

Development:
```bash
flutter run --dart-define-from-file=env/dev.json
```

Production Build:
```bash
flutter build appbundle --dart-define-from-file=env/prod.json
```

## 8. Security Notes

- All tables have RLS enabled
- Users can only modify their own data
- Storage policies prevent unauthorized access
- Geographic data is properly indexed for performance