import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../viewmodels/jobs_feed_viewmodel.dart';
import '../models/job_models.dart';
import '../components/job_row.dart';
import '../components/jobs_filter_bar.dart';
import '../components/empty_state_view.dart';
import '../components/error_state_view.dart';
import '../components/loading_skeleton.dart';
import '../navigation/jobs_router.dart';
import '../services/jobs_service.dart';

class JobsFeedView extends HookConsumerWidget {
  const JobsFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsState = ref.watch(jobsFeedProvider);

    // Search controller
    final searchController = useTextEditingController();
    final searchFocusNode = useFocusNode();

    // Scroll controller for pagination
    final scrollController = useScrollController();

    // Handle scroll for pagination
    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          final hasMoreData = ref.read(jobsFeedProvider.notifier).hasMoreData;
          if (hasMoreData) {
            ref.read(jobsFeedProvider.notifier).loadJobs();
          }
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Jobs',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          // Post Job button (for clients)
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => context.go('/listings/jobs/post'),
            tooltip: 'Post a Job',
          ),
          // Manage Jobs button (for clients)
          IconButton(
            icon: const Icon(Icons.work_outline, color: Colors.white),
            onPressed: () => context.go('/listings/jobs/manage'),
            tooltip: 'Manage My Jobs',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              controller: searchController,
              focusNode: searchFocusNode,
              hintText: 'Search jobs...',
              leading: const Icon(Icons.search),
              trailing: [
                if (searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      // TODO: Implement search clearing
                    },
                  ),
              ],
              onChanged: (query) {
                // TODO: Implement search
              },
              onSubmitted: (_) => searchFocusNode.unfocus(),
            ),
          ),
          
          // Jobs List
          Expanded(
            child: jobsState.when(
              data: (jobs) {
                if (jobs.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.work_outline,
                    title: 'No Jobs Found',
                    message: 'There are no jobs available at the moment.',
                    actionText: 'Post a Job',
                    onAction: () => context.go('/listings/jobs/post'),
                  );
                }
                
                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: JobRow(
                        job: job,
                        onTap: () => context.push('/listings/jobs/detail/${job.id}'),
                      ),
                    );
                  },
                );
              },
              loading: () => const LoadingSkeleton(),
              error: (error, stack) => ErrorStateView(
                error: error.toString(),
                onRetry: () {
                  ref.read(jobsFeedProvider.notifier).loadJobs();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: - Loading Skeleton
class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title skeleton
              Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              
              // Description skeleton
              Container(
                height: 16,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 16,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              
              // Budget and location skeleton
              Row(
                children: [
                  Container(
                    height: 16,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    height: 16,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// MARK: - Search Bar Widget
class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Widget? leading;
  final List<Widget>? trailing;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const SearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.leading,
    this.trailing,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          prefixIcon: leading,
          suffixIcon: trailing != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: trailing!,
                )
              : null,
        ),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

// MARK: - Preview
class JobsFeedViewPreview extends StatelessWidget {
  const JobsFeedViewPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: JobsFeedView(),
    );
  }
}
