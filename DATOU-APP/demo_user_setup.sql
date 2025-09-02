-- Demo User Setup for DATOU App
-- Run this in your Supabase SQL editor to create demo accounts

-- Create demo agency user (for job management testing)
INSERT INTO auth.users (
  id,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  raw_app_meta_data,
  raw_user_meta_data,
  is_super_admin,
  confirmed_at,
  email_change_confirm_status,
  banned_until,
  reauthentication_sent_at,
  last_sign_in_at,
  app_metadata,
  user_metadata,
  identities,
  aud,
  role
) VALUES (
  gen_random_uuid(),
  'demo@datou.app',
  crypt('demo123456', gen_salt('bf')),
  now(),
  now(),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"name":"Demo Agency"}',
  false,
  now(),
  0,
  null,
  null,
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"name":"Demo Agency","role":"agency"}',
  '[]',
  'authenticated',
  'authenticated'
) ON CONFLICT (email) DO NOTHING;

-- Create demo creator user (for creator features testing)
INSERT INTO auth.users (
  id,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  raw_app_meta_data,
  raw_user_meta_data,
  is_super_admin,
  confirmed_at,
  email_change_confirm_status,
  banned_until,
  reauthentication_sent_at,
  last_sign_in_at,
  app_metadata,
  user_metadata,
  identities,
  aud,
  role
) VALUES (
  gen_random_uuid(),
  'creator@datou.app',
  crypt('demo123456', gen_salt('bf')),
  now(),
  now(),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"name":"Demo Creator"}',
  false,
  now(),
  0,
  null,
  null,
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"name":"Demo Creator","role":"photographer"}',
  '[]',
  'authenticated',
  'authenticated'
) ON CONFLICT (email) DO NOTHING;

-- Create profiles for demo users
INSERT INTO profiles (
  id,
  email,
  full_name,
  username,
  bio,
  avatar_url,
  role,
  location_text,
  hourly_rate,
  years_experience,
  is_verified,
  rating,
  total_jobs,
  created_at,
  updated_at
) 
SELECT 
  u.id,
  u.email,
  u.raw_user_meta_data->>'name' as full_name,
  CASE 
    WHEN u.email = 'demo@datou.app' THEN 'demo_agency'
    WHEN u.email = 'creator@datou.app' THEN 'demo_creator'
  END as username,
  CASE 
    WHEN u.email = 'demo@datou.app' THEN 'Demo agency account for testing job management features'
    WHEN u.email = 'creator@datou.app' THEN 'Demo creator account for testing creator features'
  END as bio,
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150' as avatar_url,
  CASE 
    WHEN u.email = 'demo@datou.app' THEN 'agency'::user_role
    WHEN u.email = 'creator@datou.app' THEN 'photographer'::user_role
  END as role,
  'New York, NY' as location_text,
  CASE 
    WHEN u.email = 'demo@datou.app' THEN 0.0
    WHEN u.email = 'creator@datou.app' THEN 75.0
  END as hourly_rate,
  CASE 
    WHEN u.email = 'demo@datou.app' THEN 0
    WHEN u.email = 'creator@datou.app' THEN 5
  END as years_experience,
  true as is_verified,
  CASE 
    WHEN u.email = 'demo@datou.app' THEN 0.0
    WHEN u.email = 'creator@datou.app' THEN 4.8
  END as rating,
  CASE 
    WHEN u.email = 'demo@datou.app' THEN 0
    WHEN u.email = 'creator@datou.app' THEN 25
  END as total_jobs,
  u.created_at,
  u.updated_at
FROM auth.users u
WHERE u.email IN ('demo@datou.app', 'creator@datou.app')
ON CONFLICT (id) DO UPDATE SET
  email = EXCLUDED.email,
  full_name = EXCLUDED.full_name,
  username = EXCLUDED.username,
  bio = EXCLUDED.bio,
  avatar_url = EXCLUDED.avatar_url,
  role = EXCLUDED.role,
  location_text = EXCLUDED.location_text,
  hourly_rate = EXCLUDED.hourly_rate,
  years_experience = EXCLUDED.years_experience,
  is_verified = EXCLUDED.is_verified,
  rating = EXCLUDED.rating,
  total_jobs = EXCLUDED.total_jobs,
  updated_at = now();

-- Create some demo jobs for the agency
INSERT INTO jobs (
  id,
  client_id,
  title,
  description,
  budget,
  currency,
  location_type,
  location_text,
  status,
  created_at,
  updated_at
)
SELECT 
  gen_random_uuid(),
  p.id,
  'Demo Photography Project',
  'A demo job for testing the job management system. This is a sample photography project.',
  500.00,
  'USD',
  'remote',
  'Remote',
  'open',
  now(),
  now()
FROM profiles p
WHERE p.email = 'demo@datou.app'
ON CONFLICT DO NOTHING;

-- Create some demo applications for the job
INSERT INTO applications (
  id,
  job_id,
  creator_id,
  cover_letter,
  proposed_amount,
  proposed_terms,
  status,
  created_at,
  updated_at
)
SELECT 
  gen_random_uuid(),
  j.id,
  p.id,
  'I am interested in this demo photography project and would love to work with you!',
  450.00,
  'I can complete this project within 2 weeks with 50% upfront payment.',
  'pending',
  now(),
  now()
FROM jobs j
JOIN profiles p ON p.email = 'creator@datou.app'
WHERE j.title = 'Demo Photography Project'
ON CONFLICT DO NOTHING;

-- Verify the setup
SELECT 
  'Demo users created successfully!' as message,
  COUNT(*) as total_users
FROM auth.users 
WHERE email IN ('demo@datou.app', 'creator@datou.app');

SELECT 
  'Demo profiles created successfully!' as message,
  COUNT(*) as total_profiles
FROM profiles 
WHERE email IN ('demo@datou.app', 'creator@datou.app');

SELECT 
  'Demo jobs created successfully!' as message,
  COUNT(*) as total_jobs
FROM jobs j
JOIN profiles p ON j.client_id = p.id
WHERE p.email = 'demo@datou.app';

SELECT 
  'Demo applications created successfully!' as message,
  COUNT(*) as total_applications
FROM applications a
JOIN jobs j ON a.job_id = j.id
JOIN profiles p ON j.client_id = p.id
WHERE p.email = 'demo@datou.app';
