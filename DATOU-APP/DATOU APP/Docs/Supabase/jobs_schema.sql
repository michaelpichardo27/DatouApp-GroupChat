-- Jobs Feature Database Schema
-- This file contains the complete SQL schema for the DATOU Jobs marketplace feature

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types for jobs
CREATE TYPE job_status AS ENUM ('open', 'hiring', 'closed');
CREATE TYPE location_type AS ENUM ('remote', 'onsite', 'hybrid');
CREATE TYPE application_status AS ENUM ('submitted', 'shortlisted', 'declined', 'hired');
CREATE TYPE currency AS ENUM ('USD', 'EUR', 'GBP', 'CAD', 'AUD');

-- Jobs table
CREATE TABLE jobs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    client_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    budget_min INTEGER NOT NULL CHECK (budget_min > 0),
    budget_max INTEGER NOT NULL CHECK (budget_max >= budget_min),
    currency currency DEFAULT 'USD',
    is_fixed_price BOOLEAN DEFAULT FALSE,
    timeline_start DATE NOT NULL,
    timeline_end DATE NOT NULL CHECK (timeline_end > timeline_start),
    location_type location_type NOT NULL,
    location_city TEXT,
    location_region TEXT,
    location_country TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    requirements JSONB NOT NULL DEFAULT '{}',
    status job_status DEFAULT 'open',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Applications table
CREATE TABLE applications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    job_id UUID REFERENCES jobs(id) ON DELETE CASCADE NOT NULL,
    creator_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    cover_letter TEXT NOT NULL,
    proposed_amount INTEGER NOT NULL CHECK (proposed_amount > 0),
    proposed_terms TEXT,
    status application_status DEFAULT 'submitted',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Hires table
CREATE TABLE hires (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    job_id UUID REFERENCES jobs(id) ON DELETE CASCADE NOT NULL,
    application_id UUID REFERENCES applications(id) ON DELETE CASCADE NOT NULL,
    agreed_amount INTEGER NOT NULL CHECK (agreed_amount > 0),
    agreed_terms TEXT NOT NULL,
    hired_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX idx_jobs_status_created_at ON jobs(status, created_at DESC);
CREATE INDEX idx_jobs_client_id ON jobs(client_id);
CREATE INDEX idx_jobs_location_type ON jobs(location_type);
CREATE INDEX idx_jobs_budget_range ON jobs(budget_min, budget_max);
CREATE INDEX idx_jobs_timeline ON jobs(timeline_start, timeline_end);
CREATE INDEX idx_jobs_search ON jobs USING GIN(to_tsvector('english', title || ' ' || description));

CREATE INDEX idx_applications_job_id ON applications(job_id);
CREATE INDEX idx_applications_creator_id ON applications(creator_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_applications_created_at ON applications(created_at DESC);

CREATE INDEX idx_hires_job_id ON hires(job_id);
CREATE INDEX idx_hires_application_id ON hires(application_id);

-- Enable Row Level Security
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE hires ENABLE ROW LEVEL SECURITY;

-- RLS Policies for jobs table
CREATE POLICY "Anyone can view active jobs" ON jobs
    FOR SELECT USING (is_active = true);

CREATE POLICY "Users can create jobs" ON jobs
    FOR INSERT WITH CHECK (auth.uid() = client_id);

CREATE POLICY "Job owners can update their jobs" ON jobs
    FOR UPDATE USING (auth.uid() = client_id);

CREATE POLICY "Job owners can delete their jobs" ON jobs
    FOR DELETE USING (auth.uid() = client_id);

-- RLS Policies for applications table
CREATE POLICY "Creators can submit applications" ON applications
    FOR INSERT WITH CHECK (auth.uid() = creator_id);

CREATE POLICY "Job clients can view applications for their jobs" ON applications
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM jobs 
            WHERE jobs.id = applications.job_id 
            AND jobs.client_id = auth.uid()
        )
    );

CREATE POLICY "Creators can view their own applications" ON applications
    FOR SELECT USING (auth.uid() = creator_id);

CREATE POLICY "Job clients can update application status" ON applications
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM jobs 
            WHERE jobs.id = applications.job_id 
            AND jobs.client_id = auth.uid()
        )
    );

-- RLS Policies for hires table
CREATE POLICY "Job clients can create hires" ON hires
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM jobs 
            WHERE jobs.id = hires.job_id 
            AND jobs.client_id = auth.uid()
        )
    );

CREATE POLICY "Job clients can view hires for their jobs" ON hires
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM jobs 
            WHERE jobs.id = hires.job_id 
            AND jobs.client_id = auth.uid()
        )
    );

CREATE POLICY "Hired creators can view their hires" ON hires
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM applications 
            WHERE applications.id = hires.application_id 
            AND applications.creator_id = auth.uid()
        )
    );

-- Functions and Triggers
CREATE OR REPLACE FUNCTION update_jobs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_jobs_updated_at BEFORE UPDATE ON jobs
    FOR EACH ROW EXECUTE FUNCTION update_jobs_updated_at();

-- Function to automatically update job status when hire is created
CREATE OR REPLACE FUNCTION update_job_status_on_hire()
RETURNS TRIGGER AS $$
BEGIN
    -- Update job status to 'hiring' when a hire is created
    UPDATE jobs 
    SET status = 'hiring'::job_status
    WHERE id = NEW.job_id;
    
    -- Update application status to 'hired'
    UPDATE applications 
    SET status = 'hired'::application_status
    WHERE id = NEW.application_id;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_job_status_on_hire AFTER INSERT ON hires
    FOR EACH ROW EXECUTE FUNCTION update_job_status_on_hire();

-- Function to validate job requirements JSON structure
CREATE OR REPLACE FUNCTION validate_job_requirements()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if requirements has required fields
    IF NOT (NEW.requirements ? 'skills' OR NEW.requirements ? 'gear' OR NEW.requirements ? 'notes') THEN
        RAISE EXCEPTION 'Job requirements must contain at least one of: skills, gear, or notes';
    END IF;
    
    -- Validate skills array if present
    IF NEW.requirements ? 'skills' THEN
        IF NOT (NEW.requirements->'skills' IS NOT NULL AND jsonb_typeof(NEW.requirements->'skills') = 'array') THEN
            RAISE EXCEPTION 'Skills must be an array';
        END IF;
    END IF;
    
    -- Validate gear array if present
    IF NEW.requirements ? 'gear' THEN
        IF NOT (NEW.requirements->'gear' IS NOT NULL AND jsonb_typeof(NEW.requirements->'gear') = 'array') THEN
            RAISE EXCEPTION 'Gear must be an array';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER validate_job_requirements BEFORE INSERT OR UPDATE ON jobs
    FOR EACH ROW EXECUTE FUNCTION validate_job_requirements();

-- Function to get jobs with application count
CREATE OR REPLACE FUNCTION get_jobs_with_application_count(
    p_status job_status DEFAULT NULL,
    p_search TEXT DEFAULT NULL,
    p_limit INTEGER DEFAULT 20,
    p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
    id UUID,
    client_id UUID,
    title TEXT,
    description TEXT,
    budget_min INTEGER,
    budget_max INTEGER,
    currency currency,
    is_fixed_price BOOLEAN,
    timeline_start DATE,
    timeline_end DATE,
    location_type location_type,
    location_city TEXT,
    location_region TEXT,
    location_country TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    requirements JSONB,
    status job_status,
    is_active BOOLEAN,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    application_count BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        j.*,
        COALESCE(COUNT(a.id), 0)::BIGINT as application_count
    FROM jobs j
    LEFT JOIN applications a ON j.id = a.job_id
    WHERE j.is_active = true
        AND (p_status IS NULL OR j.status = p_status)
        AND (p_search IS NULL OR 
             j.title ILIKE '%' || p_search || '%' OR 
             j.description ILIKE '%' || p_search || '%')
    GROUP BY j.id
    ORDER BY j.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get job statistics for a client
CREATE OR REPLACE FUNCTION get_client_job_stats(p_client_id UUID)
RETURNS TABLE (
    total_jobs BIGINT,
    open_jobs BIGINT,
    hiring_jobs BIGINT,
    closed_jobs BIGINT,
    total_applications BIGINT,
    total_hires BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(DISTINCT j.id)::BIGINT as total_jobs,
        COUNT(DISTINCT CASE WHEN j.status = 'open' THEN j.id END)::BIGINT as open_jobs,
        COUNT(DISTINCT CASE WHEN j.status = 'hiring' THEN j.id END)::BIGINT as hiring_jobs,
        COUNT(DISTINCT CASE WHEN j.status = 'closed' THEN j.id END)::BIGINT as closed_jobs,
        COUNT(DISTINCT a.id)::BIGINT as total_applications,
        COUNT(DISTINCT h.id)::BIGINT as total_hires
    FROM jobs j
    LEFT JOIN applications a ON j.id = a.job_id
    LEFT JOIN hires h ON j.id = h.job_id
    WHERE j.client_id = p_client_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get creator application stats
CREATE OR REPLACE FUNCTION get_creator_application_stats(p_creator_id UUID)
RETURNS TABLE (
    total_applications BIGINT,
    submitted_applications BIGINT,
    shortlisted_applications BIGINT,
    declined_applications BIGINT,
    hired_applications BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::BIGINT as total_applications,
        COUNT(CASE WHEN status = 'submitted' THEN 1 END)::BIGINT as submitted_applications,
        COUNT(CASE WHEN status = 'shortlisted' THEN 1 END)::BIGINT as shortlisted_applications,
        COUNT(CASE WHEN status = 'declined' THEN 1 END)::BIGINT as declined_applications,
        COUNT(CASE WHEN status = 'hired' THEN 1 END)::BIGINT as hired_applications
    FROM applications
    WHERE creator_id = p_creator_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO anon, authenticated;

-- Insert sample data for testing (optional)
INSERT INTO jobs (
    client_id,
    title,
    description,
    budget_min,
    budget_max,
    currency,
    is_fixed_price,
    timeline_start,
    timeline_end,
    location_type,
    location_city,
    location_region,
    location_country,
    requirements
) VALUES 
(
    '00000000-0000-0000-0000-000000000001'::UUID,
    'Professional Product Photography',
    'Looking for a skilled photographer to capture high-quality product images for our e-commerce store. Need 50+ products photographed with consistent lighting and styling.',
    500,
    1500,
    'USD',
    false,
    CURRENT_DATE + INTERVAL '7 days',
    CURRENT_DATE + INTERVAL '21 days',
    'onsite',
    'Los Angeles',
    'CA',
    'USA',
    '{"skills": ["Product Photography", "Lighting", "Post-processing"], "gear": ["Professional Camera", "Studio Lighting", "Tripod"], "notes": "Must have portfolio of product photography work"}'
),
(
    '00000000-0000-0000-0000-000000000002'::UUID,
    'Corporate Event Videography',
    'Need a videographer for our annual company conference. 2-day event with keynote speakers and breakout sessions.',
    2000,
    3500,
    'USD',
    false,
    CURRENT_DATE + INTERVAL '14 days',
    CURRENT_DATE + INTERVAL '15 days',
    'onsite',
    'New York',
    'NY',
    'USA',
    '{"skills": ["Event Videography", "Multi-camera Setup", "Live Streaming"], "gear": ["4K Camera", "Gimbal", "Wireless Audio"], "notes": "Experience with corporate events preferred"}'
),
(
    '00000000-0000-0000-0000-000000000003'::UUID,
    'Remote UI/UX Design Consultation',
    'Seeking a senior UI/UX designer for remote consultation on our mobile app redesign project.',
    800,
    800,
    'USD',
    true,
    CURRENT_DATE + INTERVAL '3 days',
    CURRENT_DATE + INTERVAL '10 days',
    'remote',
    NULL,
    NULL,
    NULL,
    '{"skills": ["UI/UX Design", "Mobile Design", "User Research"], "gear": ["Design Software", "Prototyping Tools"], "notes": "Minimum 5 years experience in mobile app design"}'
);

-- Comments for documentation
COMMENT ON TABLE jobs IS 'Stores job postings from clients seeking creators';
COMMENT ON TABLE applications IS 'Stores applications from creators for specific jobs';
COMMENT ON TABLE hires IS 'Stores confirmed hires when clients select creators';
COMMENT ON FUNCTION get_jobs_with_application_count IS 'Returns jobs with application counts for the feed';
COMMENT ON FUNCTION get_client_job_stats IS 'Returns job statistics for a specific client';
COMMENT ON FUNCTION get_creator_application_stats IS 'Returns application statistics for a specific creator';
