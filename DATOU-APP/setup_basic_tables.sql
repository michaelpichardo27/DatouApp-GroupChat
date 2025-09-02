-- Basic setup for DATOU app listings
-- Run this in Supabase SQL Editor

-- Create enums
DO $$ BEGIN
    CREATE TYPE user_role AS ENUM ('photographer', 'videographer', 'model', 'agency');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE listing_type AS ENUM ('photography', 'videography', 'modeling', 'casting');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE listing_status AS ENUM ('draft', 'active', 'paused', 'completed', 'cancelled');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  role user_role NOT NULL DEFAULT 'photographer',
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create listings table
CREATE TABLE IF NOT EXISTS listings (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  creator_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  type listing_type NOT NULL,
  location_text TEXT NOT NULL,
  budget DECIMAL(10,2),
  status listing_status DEFAULT 'draft',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Drop existing policies first to avoid conflicts
DROP POLICY IF EXISTS "Users can insert their own listings" ON listings;
DROP POLICY IF EXISTS "Users can view their own listings" ON listings;
DROP POLICY IF EXISTS "Public listings are viewable by everyone" ON listings;
DROP POLICY IF EXISTS "Users can manage their own profile" ON users;

-- Create RLS Policies
CREATE POLICY "Users can insert their own listings" ON listings
  FOR INSERT WITH CHECK (auth.uid() = creator_id);

CREATE POLICY "Users can view their own listings" ON listings
  FOR SELECT USING (auth.uid() = creator_id);

CREATE POLICY "Public listings are viewable by everyone" ON listings
  FOR SELECT USING (status = 'active');

CREATE POLICY "Users can manage their own profile" ON users
  FOR ALL USING (auth.uid() = id);
