import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants.dart';
import '../../../core/models/profile_model.dart';
import '../../../core/services/persistent_storage_service.dart';
import '../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.session?.user,
    loading: () => null,
    error: (_, __) => null,
  );
});

final userRoleProvider = Provider<UserRole?>((ref) {
  // Recompute the user's role whenever the authentication state changes
  // so routing decisions always reflect the latest session metadata.
  final _ = ref.watch(authStateProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.getUserRole();
});

final selectedRoleProvider = StateProvider<UserRole?>((ref) => null);

final authLoadingProvider = StateProvider<bool>((ref) => false);

// Initialize guest mode from persistent storage
final guestModeProvider = StateNotifierProvider<GuestModeNotifier, bool>((ref) {
  return GuestModeNotifier();
});

// Initialize hasSkippedRoleSelection from persistent storage
final hasSkippedRoleSelectionProvider = StateNotifierProvider<HasSkippedRoleSelectionNotifier, bool>((ref) {
  return HasSkippedRoleSelectionNotifier();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  final isGuest = ref.watch(guestModeProvider);
  return user != null || isGuest;
});

// Provider to check if user should be redirected to login
final shouldRedirectToLoginProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  final isGuest = ref.watch(guestModeProvider);
  final rememberMe = ref.watch(rememberMeProvider);
  
  // Only redirect to login if user is not authenticated and not in guest mode
  // and remember me is not enabled
  return user == null && !isGuest && !rememberMe;
});

// Provider for user profile data
final userProfileProvider = FutureProvider<Profile?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  
  try {
    final supabase = Supabase.instance.client;
    print('Fetching profile for user: ${user.id}');
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
    
    print('Profile found: $response');
    return Profile.fromJson(response);
  } catch (e) {
    print('Error fetching profile: $e');
    // If profile doesn't exist, return null
    return null;
  }
});

// Provider for remember me state
final rememberMeProvider = StateNotifierProvider<RememberMeNotifier, bool>((ref) {
  return RememberMeNotifier();
});

// Notifier for guest mode with persistent storage
class GuestModeNotifier extends StateNotifier<bool> {
  GuestModeNotifier() : super(false) {
    _loadGuestMode();
  }

  Future<void> _loadGuestMode() async {
    // For demo purposes, always start with guest mode as false
    // This ensures users see the login screen every time
    state = false;
  }

  Future<void> setGuestMode(bool value) async {
    state = value;
    await PersistentStorageService.setGuestMode(value);
  }

  Future<void> clearGuestMode() async {
    state = false;
    await PersistentStorageService.setGuestMode(false);
  }
}

// Notifier for hasSkippedRoleSelection with persistent storage
class HasSkippedRoleSelectionNotifier extends StateNotifier<bool> {
  HasSkippedRoleSelectionNotifier() : super(false) {
    _loadHasSkippedRoleSelection();
  }

  Future<void> _loadHasSkippedRoleSelection() async {
    // For demo purposes, always start with false
    // This ensures users go through role selection if needed
    state = false;
  }

  Future<void> setHasSkippedRoleSelection(bool value) async {
    state = value;
    await PersistentStorageService.setHasSkippedRoleSelection(value);
  }

  Future<void> clearHasSkippedRoleSelection() async {
    state = false;
    await PersistentStorageService.setHasSkippedRoleSelection(false);
  }
}

// Notifier for remember me with persistent storage
class RememberMeNotifier extends StateNotifier<bool> {
  RememberMeNotifier() : super(false) {
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    // For demo purposes, always start with remember me as false
    // This ensures fresh start every time
    state = false;
  }

  Future<void> setRememberMe(bool value) async {
    state = value;
    await PersistentStorageService.setRememberMe(value);
    
    // If remember me is false, clear all auth data
    if (!value) {
      await PersistentStorageService.clearAllAuthData();
    }
  }
}

// Provider to check user permissions based on role
final userPermissionsProvider = Provider<UserPermissions>((ref) {
  final userRole = ref.watch(userRoleProvider);
  final isGuest = ref.watch(guestModeProvider);
  
  return UserPermissions(
    role: userRole,
    isGuest: isGuest,
  );
});

// User permissions class
class UserPermissions {
  final UserRole? role;
  final bool isGuest;

  const UserPermissions({
    required this.role,
    required this.isGuest,
  });

  // Creator permissions (photographer, videographer, model)
  bool get canCreateListings => !isGuest && (role == UserRole.photographer || role == UserRole.videographer || role == UserRole.model);
  bool get canCreatePosts => !isGuest && (role == UserRole.photographer || role == UserRole.videographer || role == UserRole.model);
  bool get canApplyToJobs => !isGuest && (role == UserRole.photographer || role == UserRole.videographer || role == UserRole.model);
  bool get canViewCalendar => !isGuest && (role == UserRole.photographer || role == UserRole.videographer || role == UserRole.model);
  bool get canEditProfile => !isGuest && role != null;

  // Agency permissions
  bool get canPostJobs => !isGuest && role == UserRole.agency;
  bool get canManageJobs => !isGuest && role == UserRole.agency;
  bool get canHireCreators => !isGuest && role == UserRole.agency;
  bool get canViewMyJobs => !isGuest && role == UserRole.agency;

  // Guest permissions
  bool get canBrowseListings => true; // Guests can browse listings
  bool get canViewProfiles => true; // Guests can view profiles
  bool get canSearch => true; // Guests can search

  // General permissions
  bool get isAuthenticated => !isGuest && role != null;
  bool get needsRoleSelection => isAuthenticated && role == null;
  bool get canAccessFullFeatures => isAuthenticated && role != null;
  bool get shouldRedirectToLogin => !isAuthenticated && !isGuest;
}