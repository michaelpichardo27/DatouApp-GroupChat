import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/ui/glass_container.dart';
import '../../auth/logic/auth_providers.dart';
import 'create_selection_screen.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    final userPermissions = ref.watch(userPermissionsProvider);

    void onDestinationSelected(int index) {
      ref.read(currentIndexProvider.notifier).state = index;
      
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/listings');
          break;
        case 2:
          _showCreateListingModal(context, ref);
          break;
        case 3:
          context.go('/calendar');
          break;
        case 4:
          context.go('/profile');
          break;
      }
    }
    
    // Adjust navigation items based on user permissions
    final navigationItems = _getNavigationItems(userPermissions);

    return Scaffold(
      body: child,
      bottomNavigationBar: GlassBottomNav(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: navigationItems,
      ),
    );
  }

  List<NavigationDestination> _getNavigationItems(UserPermissions userPermissions) {
    return [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const NavigationDestination(
        icon: Icon(Icons.list_outlined),
        selectedIcon: Icon(Icons.list),
        label: 'Listings',
      ),
      NavigationDestination(
        icon: const Icon(Icons.add_circle_outline),
        selectedIcon: const Icon(Icons.add_circle),
        label: userPermissions.canPostJobs ? 'Post Job' : 'Create',
      ),
      NavigationDestination(
        icon: const Icon(Icons.calendar_today_outlined),
        selectedIcon: const Icon(Icons.calendar_today),
        label: userPermissions.canViewMyJobs ? 'My Jobs' : 'Calendar',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  void _showCreateListingModal(BuildContext context, WidgetRef ref) {
    final userPermissions = ref.read(userPermissionsProvider);
    
    if (userPermissions.isGuest) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Account Required'),
          content: const Text(
            'You need to create an account to post content. Sign up to access all features!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Maybe Later'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/auth/signup');
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      );
      return;
    }
    
    // Check if user can create listings or post jobs
    if (userPermissions.canCreateListings) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => const CreateSelectionScreen(),
      );
    } else if (userPermissions.canPostJobs) {
      // Navigate to job posting
      context.go('/listings/jobs/post');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
            'You need to be a creator (photographer, videographer, or model) to create listings, or an agency to post jobs.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}