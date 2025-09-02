# 🚨 DATOU Schema Troubleshooting Guide

## Common Errors and Solutions

### 1. **Type Already Exists Error**
```
ERROR: 42710: type "user_role" already exists
```
**Solution**: ✅ **FIXED** - Schema now uses safe creation patterns with `DO $$ BEGIN...EXCEPTION` blocks.

### 2. **Table Already Exists Error**
```
ERROR: 42P07: relation "users" already exists
```
**Solution**: ✅ **FIXED** - All tables use `CREATE TABLE IF NOT EXISTS`.

### 3. **Index Already Exists Error**
```
ERROR: 42P07: relation "idx_listings_creator_id" already exists
```
**Solution**: ✅ **FIXED** - All indexes use `CREATE INDEX IF NOT EXISTS`.

### 4. **Policy Already Exists Error**
```
ERROR: 42710: policy "Public listings are viewable by everyone" for table "listings" already exists
```
**Solution**: ✅ **FIXED** - All policies use `DROP POLICY IF EXISTS` before creation.

### 5. **Trigger Already Exists Error**
```
ERROR: 42710: trigger "trigger_update_listing_search_vector" for relation "listings" already exists
```
**Solution**: ✅ **FIXED** - All triggers use `DROP TRIGGER IF EXISTS` before creation.

## 🚀 How to Run the Schema

### **Option 1: Safe Run (Recommended)**
1. Copy `supabase_schema.sql`
2. Paste in Supabase SQL Editor
3. Click "Run"
4. ✅ **No errors expected** - Schema handles existing objects gracefully

### **Option 2: Fresh Start (If you want to reset everything)**
1. Uncomment cleanup lines in schema:
   ```sql
   DROP TABLE IF EXISTS user_preferences CASCADE;
   DROP TABLE IF EXISTS listing_saves CASCADE;
   DROP TABLE IF EXISTS listings CASCADE;
   DROP TABLE IF EXISTS users CASCADE;
   ```
2. Run schema
3. Re-comment cleanup lines for future runs

### **Option 3: Verify Everything Works**
1. Run `supabase_schema.sql`
2. Run `test_schema.sql` to verify all components exist
3. Check that all tests show ✅ EXISTS

## 🔍 What to Check If You Still Get Errors

### **Check Supabase Dashboard:**
1. **Table Editor** - Verify tables exist
2. **SQL Editor** - Check for any error messages
3. **Database** - Look for any failed operations

### **Common Issues:**
1. **Permissions** - Make sure you're running as a database owner
2. **Extensions** - Some extensions might not be available in your Supabase plan
3. **Version** - Ensure you're using a recent version of Supabase

## 📱 Testing Your Flutter App

### **After Schema Success:**
1. **Run your Flutter app**
2. **Check console** for Supabase connection status
3. **Verify** that listings load without errors

### **If App Still Has Issues:**
1. **Check Supabase credentials** in your Flutter app
2. **Verify table names** match what your app expects
3. **Test connection** using the test script

## 🆘 Still Having Issues?

### **Debug Steps:**
1. **Run test_schema.sql** and share the output
2. **Check Supabase logs** for detailed error messages
3. **Verify your Supabase project** has the necessary permissions

### **Get Help:**
- Share the exact error message
- Include the output from `test_schema.sql`
- Mention your Supabase plan type

---

## ✅ **Current Status: All Known Issues Fixed!**

The schema is now **bulletproof** and handles all common scenarios:
- ✅ **Safe enum creation**
- ✅ **Safe table creation** 
- ✅ **Safe index creation**
- ✅ **Safe trigger creation**
- ✅ **Safe policy creation**
- ✅ **Graceful error handling**

**Next step**: Run the schema and enjoy your DATOU marketplace! 🎉
