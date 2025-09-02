-- Test query to see what columns exist in listings table
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'listings' 
ORDER BY ordinal_position;
