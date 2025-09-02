class AppConstants {
  // Supabase Configuration
  static String get supabaseUrl => 'https://mjihiffgjsssxpnhvnmi.supabase.co';
  static String get supabaseAnonKey => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1qaWhpZmZnanNzc3hwbmh2bm1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY1MDYyNzQsImV4cCI6MjA3MjA4MjI3NH0.lC8fJ8EdzsZjjj4hij852EPYBtyj_e-MgyxarHM0HfA'; // You'll need to get this from your project
  
  // App Information
  static String get appName => 'DATOU';
  static String get appVersion => '1.0.0';
}

enum UserRole {
  photographer,
  videographer,
  model,
  agency,
}

enum NavTab {
  home,
  listings,
  create,
  calendar,
  profile,
}