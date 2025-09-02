import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../constants.dart';
import '../theme/app_theme.dart';
import '../ui/glass_container.dart';
import '../../features/auth/ui/sign_up_screen.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/guest_continue_screen.dart';
import '../../features/onboarding/ui/role_selection_screen.dart';
import '../../features/onboarding/ui/terms_screen.dart';
import '../../features/content/ui/create_post_screen.dart';
import '../../features/main/ui/main_scaffold.dart';
import '../../features/home/ui/home_feed_screen.dart';
import '../../features/listings/ui/listings_screen.dart';
import '../../features/listings/ui/create_listing_flow.dart';
import '../../features/listings/ui/my_listings_screen.dart';
import '../../features/listings/ui/edit_listing_screen.dart';
import '../../features/calendar/ui/calendar_screen.dart';
import '../../features/calendar/ui/my_jobs_screen.dart';
import '../../features/profile/ui/profile_screen.dart';
import '../../features/profile/ui/settings_screen.dart';
import '../../features/profile/ui/edit_profile_screen.dart';
import '../../features/jobs/views/jobs_feed_view.dart';
import '../../features/jobs/views/job_detail_view.dart';
import '../../features/jobs/views/post_job_flow_view.dart';
import '../../features/jobs/views/manage_my_jobs_view.dart';
import '../../features/jobs/views/applicants_list_view.dart';
import '../../features/jobs/views/hire_confirmation_view.dart';
import '../../features/jobs/views/job_settings_view.dart';
import '../../features/auth/logic/auth_providers.dart';
import '../../features/jobs/views/create_job_screen.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final userRole = ref.watch(userRoleProvider);
  final isGuest = ref.watch(guestModeProvider);
  final hasSkippedRoleSelection = ref.watch(hasSkippedRoleSelectionProvider);
  final rememberMe = ref.watch(rememberMeProvider);
  final userPermissions = ref.watch(userPermissionsProvider);
  
  return GoRouter(
    debugLogDiagnostics: true,
    // Global transition: subtle fade for seamless feel
    routes: [
      GoRoute(
        path: '/auth/signup',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignUpScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/auth/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/auth/guest',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const GuestContinueScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/role-selection',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RoleSelectionScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/terms',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const TermsAcceptanceScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/create-post',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CreatePostScreen(),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/main',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainScaffold(child: HomeFeedScreen()),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainScaffold(child: HomeFeedScreen()),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/listings',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainScaffold(child: ListingsScreen()),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/create',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainScaffold(child: CreateListingFlow()),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/my-listings',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainScaffold(child: MyListingsScreen()),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/edit-listing/:id',
        pageBuilder: (context, state) {
          final listingId = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: MainScaffold(
              child: EditListingScreen(listingId: listingId),
            ),
            transitionsBuilder: _fadeTransition,
          );
        },
      ),
      GoRoute(
        path: '/calendar',
        pageBuilder: (context, state) {
          final role = ref.read(userRoleProvider);
          final child = role == UserRole.agency
              ? const MyJobsScreen()
              : const CalendarScreen();
          return CustomTransitionPage(
            key: state.pageKey,
            child: MainScaffold(child: child),
            transitionsBuilder: _fadeTransition,
          );
        },
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainScaffold(child: ProfileScreen()),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/profile/settings',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainScaffold(child: SettingsScreen()),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/profile/edit',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainScaffold(child: EditProfileScreen()),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      // Jobs routes
      GoRoute(
        path: '/listings/jobs',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainScaffold(child: JobsFeedView()),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/listings/jobs/detail/:id',
        pageBuilder: (context, state) {
          final jobId = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: MainScaffold(
              child: JobDetailView(jobId: jobId),
            ),
            transitionsBuilder: _fadeTransition,
          );
        },
      ),
      GoRoute(
        path: '/listings/jobs/post',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainScaffold(child: PostJobFlowView()),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/listings/jobs/manage',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainScaffold(child: ManageMyJobsView()),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/listings/jobs/applicants/:jobId',
        pageBuilder: (context, state) {
          final jobId = state.pathParameters['jobId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: MainScaffold(
              child: ApplicantsListView(jobId: jobId),
            ),
            transitionsBuilder: _fadeTransition,
          );
        },
      ),
      GoRoute(
        path: '/listings/jobs/hire/:jobId/:applicationId?',
        pageBuilder: (context, state) {
          final jobId = state.pathParameters['jobId']!;
          final applicationId = state.pathParameters['applicationId'];
          return CustomTransitionPage(
            key: state.pageKey,
            child: MainScaffold(
              child: HireConfirmationView(
                jobId: jobId,
                applicationId: applicationId,
              ),
            ),
            transitionsBuilder: _fadeTransition,
          );
        },
      ),
      GoRoute(
        path: '/listings/jobs/settings/:jobId',
        pageBuilder: (context, state) {
          final jobId = state.pathParameters['jobId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: MainScaffold(
              child: JobSettingsView(jobId: jobId),
            ),
            transitionsBuilder: _fadeTransition,
          );
        },
      ),
      GoRoute(
        path: '/listings/jobs/create',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainScaffold(child: CreateJobScreen()),
          transitionsBuilder: _fadeTransition,
        ),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState.when(
        data: (authState) => authState.session != null,
        loading: () => false,
        error: (_, __) => false,
      );
      
      final hasAccess = isLoggedIn || isGuest;
      
      // For demo purposes, always redirect to login unless on auth screens
      // This ensures users always start fresh
      if (!state.uri.path.startsWith('/auth') && !hasAccess) {
        return '/auth/login';
      }
      
      // If logged in but no role selected and hasn't skipped, redirect to role selection
      if (isLoggedIn && !isGuest && userRole == null && !hasSkippedRoleSelection && 
          state.uri.path != '/role-selection' &&
          !state.uri.path.startsWith('/setup') &&
          state.uri.path != '/terms') {
        return '/role-selection';
      }
      
      // Role-based permission checks
      if (hasAccess && !state.uri.path.startsWith('/auth')) {
        // Agency-only routes
        if (state.uri.path.startsWith('/listings/jobs/manage') && !userPermissions.canManageJobs) {
          return '/home';
        }
        if (state.uri.path.startsWith('/listings/jobs/post') && !userPermissions.canPostJobs) {
          return '/home';
        }
        if (state.uri.path.startsWith('/listings/jobs/hire') && !userPermissions.canHireCreators) {
          return '/home';
        }
        
        // Creator-only routes
        if (state.uri.path == '/create-post' && !userPermissions.canCreatePosts) {
          return '/home';
        }
        if (state.uri.path == '/create' && !userPermissions.canCreateListings) {
          return '/home';
        }
        if (state.uri.path == '/my-listings' && !userPermissions.canCreateListings) {
          return '/home';
        }
        if (state.uri.path == '/edit-listing' && !userPermissions.canCreateListings) {
          return '/home';
        }
        
        // Profile editing
        if (state.uri.path == '/profile/edit' && !userPermissions.canEditProfile) {
          return '/home';
        }
      }
      
      return null;
    },
    initialLocation: '/home',
  );
});

// Simple fade transition used across routes for a seamless feel
Widget _fadeTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondary, Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
    child: child,
  );
}