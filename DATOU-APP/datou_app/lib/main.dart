import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/routing/app_router.dart';
import 'core/providers/auth_provider.dart';
import 'core/services/persistent_storage_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );
  
  // Debug: Print Supabase connection info
  print('🔗 Connecting to Supabase:');
  print('   URL: ${AppConstants.supabaseUrl}');
  print('   Project ID: ${AppConstants.supabaseUrl.split('/').last}');
  print('   Anon Key: ${AppConstants.supabaseAnonKey.substring(0, 20)}...');
  
  // Test database connection
  try {
    final client = Supabase.instance.client;
    await client.from('listings').select('count').limit(1);
    print('✅ Database connection successful!');
    print('   Tables accessible: listings');
  } catch (e) {
    print('❌ Database connection failed: $e');
  }

  // Ensure users are NOT auto-signed-in unless they chose Remember Me
  final rememberMe = await PersistentStorageService.getRememberMe();
  if (!rememberMe) {
    try {
      await Supabase.instance.client.auth.signOut();
      await PersistentStorageService.clearAuthDataExceptRememberMe();
      print('👤 Signed out on launch (remember me disabled)');
    } catch (_) {}
  }
  
  runApp(
    const ProviderScope(
      child: DatouApp(),
    ),
  );
}

class DatouApp extends ConsumerWidget {
  const DatouApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}