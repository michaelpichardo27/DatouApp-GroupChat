-- Content Posts Database Schema
-- This file contains the SQL schema for the DATOU content posts feature

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types for content posts
CREATE TYPE post_type AS ENUM ('content', 'listing', 'portfolio', 'announcement');
CREATE TYPE interaction_type AS ENUM ('like', 'save', 'share', 'comment');

-- Content Posts table
CREATE TABLE IF NOT EXISTS content_posts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    username TEXT NOT NULL,
    user_profile_image_url TEXT,
    post_type post_type NOT NULL DEFAULT 'content',
    
    -- Content fields
    image_url TEXT NOT NULL,
    video_url TEXT,
    caption TEXT NOT NULL,
    tags TEXT[],
    
    -- Location
    location TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    
    -- Engagement metrics
    likes_count INTEGER DEFAULT 0,
    comments_count INTEGER DEFAULT 0,
    saves_count INTEGER DEFAULT 0,
    shares_count INTEGER DEFAULT 0,
    liked_by_user_ids TEXT[] DEFAULT '{}',
    saved_by_user_ids TEXT[] DEFAULT '{}',
    
    -- Collaboration/tagging
    tagged_user_ids TEXT[] DEFAULT '{}',
    tagged_usernames TEXT[] DEFAULT '{}',
    
    -- Listing association (if this is a job listing post)
    associated_listing_id UUID REFERENCES listings(id) ON DELETE SET NULL,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Privacy & settings
    is_public BOOLEAN DEFAULT TRUE,
    comments_enabled BOOLEAN DEFAULT FALSE,
    is_promoted BOOLEAN DEFAULT FALSE,
    
    -- Additional metadata
    metadata JSONB DEFAULT '{}'
);

-- Comments table
CREATE TABLE IF NOT EXISTS comments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    post_id UUID REFERENCES content_posts(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    username TEXT NOT NULL,
    user_profile_image_url TEXT,
    text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    likes_count INTEGER DEFAULT 0,
    liked_by_user_ids TEXT[] DEFAULT '{}',
    reply_to_comment_id UUID REFERENCES comments(id) ON DELETE CASCADE
);

-- Post Interactions table (for analytics)
CREATE TABLE IF NOT EXISTS post_interactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    post_id UUID REFERENCES content_posts(id) ON DELETE CASCADE NOT NULL,
    type interaction_type NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Ensure unique interactions per user per post per type
    UNIQUE(user_id, post_id, type)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_content_posts_user_id ON content_posts(user_id);
CREATE INDEX IF NOT EXISTS idx_content_posts_created_at ON content_posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_content_posts_post_type ON content_posts(post_type);
CREATE INDEX IF NOT EXISTS idx_content_posts_liked_by_user_ids ON content_posts USING GIN(liked_by_user_ids);
CREATE INDEX IF NOT EXISTS idx_content_posts_saved_by_user_ids ON content_posts USING GIN(saved_by_user_ids);
CREATE INDEX IF NOT EXISTS idx_content_posts_tags ON content_posts USING GIN(tags);

CREATE INDEX IF NOT EXISTS idx_comments_post_id ON comments(post_id);
CREATE INDEX IF NOT EXISTS idx_comments_user_id ON comments(user_id);
CREATE INDEX IF NOT EXISTS idx_comments_created_at ON comments(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_post_interactions_post_id ON post_interactions(post_id);
CREATE INDEX IF NOT EXISTS idx_post_interactions_user_id ON post_interactions(user_id);
CREATE INDEX IF NOT EXISTS idx_post_interactions_timestamp ON post_interactions(timestamp DESC);

-- Enable Row Level Security
ALTER TABLE content_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_interactions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for content_posts
CREATE POLICY "Users can view public posts" ON content_posts
    FOR SELECT USING (is_public = true);

CREATE POLICY "Users can view their own posts" ON content_posts
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own posts" ON content_posts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own posts" ON content_posts
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own posts" ON content_posts
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for comments
CREATE POLICY "Users can view comments on public posts" ON comments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM content_posts 
            WHERE content_posts.id = comments.post_id 
            AND content_posts.is_public = true
        )
    );

CREATE POLICY "Users can view comments on their own posts" ON comments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM content_posts 
            WHERE content_posts.id = comments.post_id 
            AND content_posts.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can create comments" ON comments
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own comments" ON comments
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own comments" ON comments
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for post_interactions
CREATE POLICY "Users can view interactions on public posts" ON post_interactions
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM content_posts 
            WHERE content_posts.id = post_interactions.post_id 
            AND content_posts.is_public = true
        )
    );

CREATE POLICY "Users can create their own interactions" ON post_interactions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own interactions" ON post_interactions
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own interactions" ON post_interactions
    FOR DELETE USING (auth.uid() = user_id);

-- Functions for updating engagement metrics
CREATE OR REPLACE FUNCTION update_post_likes_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE content_posts 
        SET likes_count = likes_count + 1
        WHERE id = NEW.post_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE content_posts 
        SET likes_count = likes_count - 1
        WHERE id = OLD.post_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_post_comments_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE content_posts 
        SET comments_count = comments_count + 1
        WHERE id = NEW.post_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE content_posts 
        SET comments_count = comments_count - 1
        WHERE id = OLD.post_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Triggers for automatic engagement count updates
CREATE TRIGGER trigger_update_likes_count
    AFTER INSERT OR DELETE ON post_interactions
    FOR EACH ROW
    WHEN (NEW.type = 'like' OR OLD.type = 'like')
    EXECUTE FUNCTION update_post_likes_count();

CREATE TRIGGER trigger_update_comments_count
    AFTER INSERT OR DELETE ON comments
    FOR EACH ROW
    EXECUTE FUNCTION update_post_comments_count();
