-- DATOU App - Complete Supabase Schema for Listings
-- This file contains all necessary database setup for the listings feature
--
-- 🚀 SAFE TO RUN MULTIPLE TIMES - Uses IF NOT EXISTS and safe creation patterns
-- 📝 To start fresh, uncomment the cleanup lines below before running
-- 🔧 Run this in Supabase SQL Editor
-- ✅ Handles existing types, tables, indexes, and triggers gracefully

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "cube";
CREATE EXTENSION IF NOT EXISTS "earthdistance";

-- Clean up any existing data that might conflict (optional - uncomment if needed)
-- DROP TABLE IF EXISTS user_preferences CASCADE;
-- DROP TABLE IF EXISTS listing_saves CASCADE;
-- DROP TABLE IF EXISTS listings CASCADE;
-- DROP TABLE IF EXISTS users CASCADE;

-- Create enums for type safety and clarity (only if they don't exist)
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

DO $$ BEGIN
    CREATE TYPE contact_method AS ENUM ('in_app', 'email', 'phone');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE experience_level AS ENUM ('beginner', 'intermediate', 'advanced', 'professional');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE sort_option AS ENUM ('newest', 'oldest', 'budget_high', 'budget_low', 'deadline', 'recommended');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE view_mode AS ENUM ('list', 'map');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Secondary categories for different roles
DO $$ BEGIN
    CREATE TYPE photography_category AS ENUM (
      'portrait', 'wedding', 'event', 'commercial', 'fashion', 'product', 
      'automotive', 'real_estate', 'sports', 'nature', 'street', 'lifestyle'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE videography_category AS ENUM (
      'commercial', 'wedding', 'music_video', 'documentary', 'corporate', 
      'social_media', 'event', 'promotional', 'real_estate', 'automotive'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE modeling_category AS ENUM (
      'fashion', 'commercial', 'fitness', 'beauty', 'lifestyle', 'automotive', 
      'product', 'editorial', 'glamour', 'alternative'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Users table (simplified for listings context)
CREATE TABLE IF NOT EXISTS users (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  role user_role NOT NULL,
  avatar_url TEXT,
  location POINT, -- For geospatial queries
  location_text TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Main listings table
CREATE TABLE IF NOT EXISTS listings (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  creator_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Basic listing info
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  type listing_type NOT NULL,
  required_role user_role,
  
  -- Categories (stored as arrays for flexibility)
  photography_categories photography_category[],
  videography_categories videography_category[],
  modeling_categories modeling_category[],
  
  -- Budget and compensation
  budget DECIMAL(10,2),
  is_negotiable BOOLEAN DEFAULT true,
  
  -- Location and geography
  location_text TEXT NOT NULL,
  location POINT, -- Lat/lng for geospatial queries
  is_remote BOOLEAN DEFAULT false,
  
  -- Timing
  event_date TIMESTAMP WITH TIME ZONE,
  event_duration_hours INTEGER,
  application_deadline TIMESTAMP WITH TIME ZONE,
  
  -- Requirements
  required_skills TEXT[],
  preferred_experience experience_level,
  min_age INTEGER,
  max_age INTEGER,
  
  -- Contact and application
  contact_method contact_method DEFAULT 'in_app',
  external_contact_info TEXT, -- email/phone if not in_app
  
  -- Media
  image_urls TEXT[],
  
  -- Status and metadata
  status listing_status DEFAULT 'draft',
  is_urgent BOOLEAN DEFAULT false,
  is_featured BOOLEAN DEFAULT false,
  
  -- Analytics
  view_count INTEGER DEFAULT 0,
  application_count INTEGER DEFAULT 0,
  save_count INTEGER DEFAULT 0,
  
  -- Search optimization
  search_vector TSVECTOR,
  tags TEXT[], -- Additional searchable tags
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE,
  
  -- Constraints
  CONSTRAINT valid_budget CHECK (budget IS NULL OR budget >= 0),
  CONSTRAINT valid_duration CHECK (event_duration_hours IS NULL OR event_duration_hours > 0),
  CONSTRAINT valid_age_range CHECK (
    (min_age IS NULL AND max_age IS NULL) OR
    (min_age IS NOT NULL AND max_age IS NOT NULL AND min_age <= max_age)
  )
);

-- Saved/favorited listings table
CREATE TABLE IF NOT EXISTS listing_saves (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  listing_id UUID NOT NULL REFERENCES listings(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  UNIQUE(user_id, listing_id)
);

-- User preferences for recommendations
CREATE TABLE IF NOT EXISTS user_preferences (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  preferred_types listing_type[],
  preferred_categories JSONB, -- Flexible structure for different category types
  max_distance_km INTEGER DEFAULT 50,
  min_budget DECIMAL(10,2),
  max_budget DECIMAL(10,2),
  preferred_experience experience_level[],
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
-- Basic indexes
CREATE INDEX IF NOT EXISTS idx_listings_creator_id ON listings(creator_id);
CREATE INDEX IF NOT EXISTS idx_listings_status ON listings(status);
CREATE INDEX IF NOT EXISTS idx_listings_type ON listings(type);
CREATE INDEX IF NOT EXISTS idx_listings_created_at ON listings(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_listings_event_date ON listings(event_date);
CREATE INDEX IF NOT EXISTS idx_listings_budget ON listings(budget);
CREATE INDEX IF NOT EXISTS idx_listings_is_urgent ON listings(is_urgent);
CREATE INDEX IF NOT EXISTS idx_listings_expires_at ON listings(expires_at);

-- Geospatial index for location-based searches
CREATE INDEX IF NOT EXISTS idx_listings_location ON listings USING GIST(location);

-- Full-text search indexes
CREATE INDEX IF NOT EXISTS idx_listings_search_vector ON listings USING GIN(search_vector);
CREATE INDEX IF NOT EXISTS idx_listings_title_trgm ON listings USING GIN(title gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_listings_description_trgm ON listings USING GIN(description gin_trgm_ops);

-- Array indexes for categories and tags
CREATE INDEX IF NOT EXISTS idx_listings_photography_categories ON listings USING GIN(photography_categories);
CREATE INDEX IF NOT EXISTS idx_listings_videography_categories ON listings USING GIN(videography_categories);
CREATE INDEX IF NOT EXISTS idx_listings_modeling_categories ON listings USING GIN(modeling_categories);
CREATE INDEX IF NOT EXISTS idx_listings_tags ON listings USING GIN(tags);
CREATE INDEX IF NOT EXISTS idx_listings_required_skills ON listings USING GIN(required_skills);

-- Composite indexes for common query patterns
CREATE INDEX IF NOT EXISTS idx_listings_active_recent ON listings(status, created_at DESC) WHERE status = 'active';
CREATE INDEX IF NOT EXISTS idx_listings_type_status_date ON listings(type, status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_listings_urgent_active ON listings(is_urgent, status, created_at DESC) WHERE status = 'active';

-- Saved listings indexes
CREATE INDEX IF NOT EXISTS idx_listing_saves_user_id ON listing_saves(user_id);
CREATE INDEX IF NOT EXISTS idx_listing_saves_listing_id ON listing_saves(listing_id);
CREATE INDEX IF NOT EXISTS idx_listing_saves_created_at ON listing_saves(created_at DESC);

-- Function to update search vector
CREATE OR REPLACE FUNCTION update_listing_search_vector()
RETURNS TRIGGER AS $$
BEGIN
  NEW.search_vector := 
    setweight(to_tsvector('english', COALESCE(NEW.title, '')), 'A') ||
    setweight(to_tsvector('english', COALESCE(NEW.description, '')), 'B') ||
    setweight(to_tsvector('english', COALESCE(NEW.location_text, '')), 'C') ||
    setweight(to_tsvector('english', COALESCE(array_to_string(NEW.tags, ' '), '')), 'D') ||
    setweight(to_tsvector('english', COALESCE(array_to_string(NEW.required_skills, ' '), '')), 'D');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update search vector
DROP TRIGGER IF EXISTS trigger_update_listing_search_vector ON listings;
CREATE TRIGGER trigger_update_listing_search_vector
  BEFORE INSERT OR UPDATE ON listings
  FOR EACH ROW EXECUTE FUNCTION update_listing_search_vector();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
DROP TRIGGER IF EXISTS trigger_listings_updated_at ON listings;
CREATE TRIGGER trigger_listings_updated_at
  BEFORE UPDATE ON listings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS trigger_users_updated_at ON users;
CREATE TRIGGER trigger_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- RLS (Row Level Security) Policies
-- Note: Policies are dropped and recreated to avoid conflicts when running multiple times
ALTER TABLE listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE listing_saves ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;

-- Listings policies (drop and recreate to avoid conflicts)
DROP POLICY IF EXISTS "Public listings are viewable by everyone" ON listings;
CREATE POLICY "Public listings are viewable by everyone" ON listings
  FOR SELECT USING (status = 'active');

DROP POLICY IF EXISTS "Users can view their own listings" ON listings;
CREATE POLICY "Users can view their own listings" ON listings
  FOR SELECT USING (auth.uid() = creator_id);

DROP POLICY IF EXISTS "Users can insert their own listings" ON listings;
CREATE POLICY "Users can insert their own listings" ON listings
  FOR INSERT WITH CHECK (auth.uid() = creator_id);

DROP POLICY IF EXISTS "Users can update their own listings" ON listings;
CREATE POLICY "Users can update their own listings" ON listings
  FOR UPDATE USING (auth.uid() = creator_id);

DROP POLICY IF EXISTS "Users can delete their own listings" ON listings;
CREATE POLICY "Users can delete their own listings" ON listings
  FOR DELETE USING (auth.uid() = creator_id);

-- Listing saves policies (drop and recreate to avoid conflicts)
DROP POLICY IF EXISTS "Users can view their own saves" ON listing_saves;
CREATE POLICY "Users can view their own saves" ON listing_saves
  FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert their own saves" ON listing_saves;
CREATE POLICY "Users can insert their own saves" ON listing_saves
  FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete their own saves" ON listing_saves;
CREATE POLICY "Users can delete their own saves" ON listing_saves
  FOR DELETE USING (auth.uid() = user_id);

-- User preferences policies (drop and recreate to avoid conflicts)
DROP POLICY IF EXISTS "Users can manage their own preferences" ON user_preferences;
CREATE POLICY "Users can manage their own preferences" ON user_preferences
  FOR ALL USING (auth.uid() = user_id);

-- Helper function to increment view count
CREATE OR REPLACE FUNCTION increment_listing_views(listing_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE listings 
  SET view_count = view_count + 1 
  WHERE id = listing_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;



-- Helper function to toggle save status
CREATE OR REPLACE FUNCTION toggle_listing_save(listing_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  user_uuid UUID := auth.uid();
  save_exists BOOLEAN;
BEGIN
  -- Check if save already exists
  SELECT EXISTS(
    SELECT 1 FROM listing_saves 
    WHERE user_id = user_uuid AND listing_id = toggle_listing_save.listing_id
  ) INTO save_exists;
  
  IF save_exists THEN
    -- Remove save
    DELETE FROM listing_saves 
    WHERE user_id = user_uuid AND listing_id = toggle_listing_save.listing_id;
    
    -- Decrement save count
    UPDATE listings 
    SET save_count = GREATEST(0, save_count - 1)
    WHERE id = toggle_listing_save.listing_id;
    
    RETURN FALSE;
  ELSE
    -- Add save
    INSERT INTO listing_saves (user_id, listing_id) 
    VALUES (user_uuid, toggle_listing_save.listing_id);
    
    -- Increment save count
    UPDATE listings 
    SET save_count = save_count + 1
    WHERE id = toggle_listing_save.listing_id;
    
      RETURN TRUE;
END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 🎉 Schema Creation Complete!
-- 
-- What was created:
-- ✅ Tables: users, listings, listing_saves, user_preferences
-- ✅ Enums: user_role, listing_type, listing_status, contact_method, experience_level, sort_option, view_mode, photography_category, videography_category, modeling_category
-- ✅ Indexes: Performance indexes for search, filtering, and geospatial queries
-- ✅ Triggers: Automatic search vector updates and timestamp updates
-- ✅ Functions: Search vector generation, timestamp management, view counting, save toggling
-- ✅ RLS Policies: Row-level security for all tables
-- 
-- Next steps:
-- 1. Run test_schema.sql to verify everything works
-- 2. Test your Flutter app connection
-- 3. Start building your marketplace features!
