import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/ui/glass_container.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/logic/auth_providers.dart';
import '../../calendar/logic/calendar_providers.dart';
import 'social_feed_screen.dart';

class HomeFeedScreen extends ConsumerWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Return the social media style feed
    return const SocialFeedScreen();
  }
}