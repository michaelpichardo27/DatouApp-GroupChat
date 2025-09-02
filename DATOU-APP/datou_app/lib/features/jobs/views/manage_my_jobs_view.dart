import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/job_models.dart';
import '../services/jobs_service.dart';
import '../viewmodels/jobs_feed_viewmodel.dart';
import '../components/job_row.dart';
import '../components/empty_state_view.dart';
import '../components/error_state_view.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/glass_container.dart';

class ManageMyJobsView extends HookConsumerWidget {
  const ManageMyJobsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTabIndex = useState(0);
    final tabController = useTabController(initialLength: 3);

    // Watch jobs for each status
    final openJobs = ref.watch(myJobsProvider(JobStatus.open));
    final hiringJobs = ref.watch(myJobsProvider(JobStatus.hiring));
    final closedJobs = ref.watch(myJobsProvider(JobStatus.closed));

    useEffect(() {
      // Load jobs when tab changes
      ref.read(myJobsProvider(JobStatus.open).notifier).loadJobs();
      ref.read(myJobsProvider(JobStatus.hiring).notifier).loadJobs();
      ref.read(myJobsProvider(JobStatus.closed).notifier).loadJobs();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Manage My Jobs',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to job creation screen
              context.push('/listings/jobs/create');
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                color: const Color(0xFF8B5CF6),
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[400],
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open, size: 16),
                      SizedBox(width: 8),
                      Text('Open'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work, size: 16),
                      SizedBox(width: 8),
                      Text('Hiring'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 16),
                      SizedBox(width: 8),
                      Text('Closed'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _buildJobsList(context, ref, openJobs, 'Open Jobs'),
                _buildJobsList(context, ref, hiringJobs, 'Hiring Jobs'),
                _buildJobsList(context, ref, closedJobs, 'Closed Jobs'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsList(BuildContext context, WidgetRef ref, AsyncValue<List<Job>> jobsState, String title) {
    return jobsState.when(
      data: (jobs) {
        if (jobs.isEmpty) {
          return EmptyStateView(
            icon: Icons.work_outline,
            title: 'No $title',
            message: 'You haven\'t created any ${title.toLowerCase()} yet.',
            actionText: 'Create Job',
            onAction: () {
              // Navigate to job creation screen
              context.push('/listings/jobs/create');
            },
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: _buildJobCard(context, ref, job),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
      ),
      error: (error, stack) => ErrorStateView(
        error: error.toString(),
        onRetry: () {
          // Retry loading jobs
          ref.read(myJobsProvider(JobStatus.open).notifier).loadJobs();
          ref.read(myJobsProvider(JobStatus.hiring).notifier).loadJobs();
          ref.read(myJobsProvider(JobStatus.closed).notifier).loadJobs();
        },
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, WidgetRef ref, Job job) {
    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status and actions
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      _buildStatusChip(job.status),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) => _handleJobAction(context, ref, job, value),
                  itemBuilder: (context) => _buildJobActions(job),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Job details
            _buildJobDetailRow(Icons.attach_money, 'Budget', job.budgetDisplay),
            _buildJobDetailRow(Icons.location_on, 'Location', job.locationDisplay),
            _buildJobDetailRow(Icons.calendar_today, 'Created', _formatDate(job.createdAt)),
            _buildJobDetailRow(Icons.people, 'Applications', '${_getApplicationCount(context, ref, job)} applications'),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/listings/jobs/applicants/${job.id}'),
                    icon: const Icon(Icons.people, size: 16),
                    label: const Text('View Applicants'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF8B5CF6),
                      side: const BorderSide(color: Color(0xFF8B5CF6)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (job.isOpen) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _editJob(context, job),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                ] else if (job.isHiring) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _viewHireDetails(context, job),
                      icon: const Icon(Icons.handshake, size: 16),
                      label: const Text('View Hire'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(JobStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case JobStatus.open:
        color = Colors.green;
        text = 'Open';
        break;
      case JobStatus.hiring:
        color = Colors.blue;
        text = 'Hiring';
        break;
      case JobStatus.closed:
        color = Colors.grey;
        text = 'Closed';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildJobDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400], size: 16),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildJobActions(Job job) {
    final actions = <PopupMenuEntry<String>>[];
    
    if (job.isOpen) {
      actions.addAll([
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 16),
              SizedBox(width: 8),
              Text('Edit Job'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'close',
          child: Row(
            children: [
              Icon(Icons.close, size: 16),
              SizedBox(width: 8),
              Text('Close Job'),
            ],
          ),
        ),
      ]);
    } else if (job.isHiring) {
      actions.addAll([
        const PopupMenuItem(
          value: 'reopen',
          child: Row(
            children: [
              Icon(Icons.refresh, size: 16),
              SizedBox(width: 8),
              Text('Reopen Job'),
            ],
          ),
        ),
      ]);
    }
    
    actions.addAll([
      const PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Icon(Icons.delete, size: 16, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Job', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    ]);
    
    return actions;
  }

  void _handleJobAction(BuildContext context, WidgetRef ref, Job job, String action) {
    switch (action) {
      case 'edit':
        _editJob(context, job);
        break;
      case 'close':
        _closeJob(context, ref, job);
        break;
      case 'reopen':
        _reopenJob(context, ref, job);
        break;
      case 'delete':
        _deleteJob(context, ref, job);
        break;
    }
  }

  void _editJob(BuildContext context, Job job) {
    // TODO: Navigate to job edit screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job editing coming soon!')),
    );
  }

  void _closeJob(BuildContext context, WidgetRef ref, Job job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close Job'),
        content: const Text('Are you sure you want to close this job? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(myJobsProvider(job.status).notifier).closeJob(job.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Job closed successfully!')),
                );
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error closing job: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Close Job'),
          ),
        ],
      ),
    );
  }

  void _reopenJob(BuildContext context, WidgetRef ref, Job job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reopen Job'),
        content: const Text('Are you sure you want to reopen this job?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(myJobsProvider(job.status).notifier).reopenJob(job.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Job reopened successfully!')),
                );
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error reopening job: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Reopen'),
          ),
        ],
      ),
    );
  }

  void _deleteJob(BuildContext context, WidgetRef ref, Job job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Job'),
        content: const Text('Are you sure you want to delete this job? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(myJobsProvider(job.status).notifier).deleteJob(job.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Job deleted successfully!')),
                );
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting job: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _viewHireDetails(BuildContext context, Job job) {
    // Navigate to hire details view
    context.push('/listings/jobs/hire/${job.id}');
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  int _getApplicationCount(BuildContext context, WidgetRef ref, Job job) {
    // Get application count from the applicants provider
    final applicantsState = ref.read(applicantsProvider(job.id));
    return applicantsState.when(
      data: (applicants) => applicants.length,
      loading: () => 0,
      error: (_, __) => 0,
    );
  }
}
