-- Test Script for DATOU Schema
-- Run this after the main schema to verify everything works

-- Test 1: Check if tables exist
SELECT 
  table_name,
  CASE WHEN table_name IS NOT NULL THEN '✅ EXISTS' ELSE '❌ MISSING' END as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN ('users', 'listings', 'listing_saves', 'user_preferences');

-- Test 2: Check if enums exist
SELECT 
  typname as enum_name,
  CASE WHEN typname IS NOT NULL THEN '✅ EXISTS' ELSE '❌ MISSING' END as status
FROM pg_type 
WHERE typname IN ('user_role', 'listing_type', 'listing_status', 'contact_method', 'experience_level', 'sort_option', 'view_mode', 'photography_category', 'videography_category', 'modeling_category');

-- Test 3: Check if indexes exist
SELECT 
  indexname as index_name,
  CASE WHEN indexname IS NOT NULL THEN '✅ EXISTS' ELSE '❌ MISSING' END as status
FROM pg_indexes 
WHERE schemaname = 'public' 
  AND tablename = 'listings'
  AND indexname LIKE 'idx_listings_%';

-- Test 4: Check if triggers exist
SELECT 
  trigger_name,
  CASE WHEN trigger_name IS NOT NULL THEN '✅ EXISTS' ELSE '❌ MISSING' END as status
FROM information_schema.triggers 
WHERE trigger_schema = 'public' 
  AND event_object_table IN ('users', 'listings');

-- Test 4.5: Check if RLS policies exist
SELECT 
  policyname as policy_name,
  tablename as table_name,
  CASE WHEN policyname IS NOT NULL THEN '✅ EXISTS' ELSE '❌ MISSING' END as status
FROM pg_policies 
WHERE schemaname = 'public' 
  AND tablename IN ('users', 'listings', 'listing_saves', 'user_preferences');

-- Test 5: Insert test data (optional)
-- Uncomment the lines below to test data insertion

/*
INSERT INTO users (email, full_name, role, location_text) 
VALUES ('test@example.com', 'Test User', 'photographer', 'New York, NY')
ON CONFLICT (email) DO NOTHING;

INSERT INTO listings (creator_id, title, description, type, budget, location_text, status) 
SELECT 
  u.id,
  'Test Photography Session',
  'A test listing for photography services',
  'photography',
  150.00,
  'New York, NY',
  'active'
FROM users u 
WHERE u.email = 'test@example.com'
LIMIT 1;

-- Verify test data
SELECT 
  u.email,
  l.title,
  l.type,
  l.status
FROM users u
JOIN listings l ON u.id = l.creator_id
WHERE u.email = 'test@example.com';
*/

-- Test 6: Summary
SELECT 'Schema Test Complete!' as message;
