import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/job_models.dart';
import '../viewmodels/jobs_feed_viewmodel.dart';
import '../components/empty_state_view.dart';
import '../components/error_state_view.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/glass_container.dart';

class ApplicantsListView extends HookConsumerWidget {
  final String jobId;

  const ApplicantsListView({
    super.key,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicantsState = ref.watch(applicantsProvider(jobId));
    final jobState = ref.watch(jobDetailProvider(jobId));
    final filters = useState(const ApplicationFilters());
    
    // Filter and sort applicants
    final filteredApplicants = ref.watch(filteredApplicantsProvider(jobId));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Applicants',
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
            onPressed: () => _showFiltersDialog(context, ref, filters),
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Job info header
          jobState.when(
            data: (job) {
              if (job == null) return const SizedBox.shrink();
              return _buildJobHeader(context, job);
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          
          // Applicants list
          Expanded(
            child: filteredApplicants.when(
              data: (applicants) {
                if (applicants.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.people_outline,
                    title: 'No Applicants',
                    message: 'No applicants have applied to this job yet.',
                    actionText: 'Share Job',
                    onAction: () {
                      // TODO: Implement share job
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Share job coming soon!')),
                      );
                    },
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: applicants.length,
                  itemBuilder: (context, index) {
                    final application = applicants[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: _buildApplicantCard(context, ref, application),
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
                  ref.read(applicantsProvider(jobId).notifier).loadApplicants();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobHeader(BuildContext context, Job job) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: GlassContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
              Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.grey[400], size: 16),
                  const SizedBox(width: 4),
                  Text(
                    job.budgetDisplay,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.location_on, color: Colors.grey[400], size: 16),
                  const SizedBox(width: 4),
                  Text(
                    job.locationDisplay,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplicantCard(BuildContext context, WidgetRef ref, Application application) {
    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Applicant header
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF8B5CF6),
                  child: Text(
                    _getInitials(ref, application.creatorId),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Creator info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getCreatorName(ref, application.creatorId),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${_getCreatorHandle(ref, application.creatorId)}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '4.8', // TODO: Get actual rating
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green),
                            ),
                            child: const Text(
                              'Verified',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Application status
                _buildApplicationStatusChip(application.status),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Proposal summary
            Text(
              'Proposal Summary',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              application.coverLetter,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 12),
            
            // Proposal details
            Row(
              children: [
                _buildProposalDetail('Price', '\$${application.proposedAmount}'),
                const SizedBox(width: 16),
                _buildProposalDetail('Timeline', '2-3 weeks'), // TODO: Get from application
                const SizedBox(width: 16),
                _buildProposalDetail('Submitted', _formatDate(application.createdAt)),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewProposal(context, ref, application),
                    icon: const Icon(Icons.description, size: 16),
                    label: const Text('View Proposal'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF8B5CF6),
                      side: const BorderSide(color: Color(0xFF8B5CF6)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _messageApplicant(context, application),
                    icon: const Icon(Icons.message, size: 16),
                    label: const Text('Message'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (application.isSubmitted) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _shortlistApplicant(context, ref, application),
                      icon: const Icon(Icons.star, size: 16),
                      label: const Text('Shortlist'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                ] else if (application.isShortlisted) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _hireApplicant(context, ref, application),
                      icon: const Icon(Icons.handshake, size: 16),
                      label: const Text('Hire'),
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

  Widget _buildApplicationStatusChip(ApplicationStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case ApplicationStatus.submitted:
        color = Colors.blue;
        text = 'New';
        break;
      case ApplicationStatus.shortlisted:
        color = Colors.amber;
        text = 'Shortlisted';
        break;
      case ApplicationStatus.declined:
        color = Colors.red;
        text = 'Declined';
        break;
      case ApplicationStatus.hired:
        color = Colors.green;
        text = 'Hired';
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

  Widget _buildProposalDetail(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showFiltersDialog(BuildContext context, WidgetRef ref, ValueNotifier<ApplicationFilters> filters) {
    showDialog(
      context: context,
      builder: (context) => _FiltersDialog(
        currentFilters: filters.value,
        onFiltersChanged: (newFilters) {
          filters.value = newFilters;
          ref.read(filteredApplicantsProvider(jobId).notifier).updateFilters(newFilters);
        },
      ),
    );
  }

  void _viewProposal(BuildContext context, WidgetRef ref, Application application) {
    // TODO: Navigate to full proposal view
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Proposal from ${_getCreatorName(ref, application.creatorId)}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Cover Letter',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(application.coverLetter),
              const SizedBox(height: 16),
              Text(
                'Proposed Amount: \$${application.proposedAmount}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (application.proposedTerms != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Proposed Terms:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(application.proposedTerms!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _messageApplicant(BuildContext context, Application application) {
    // TODO: Navigate to messaging
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Messaging feature coming soon!')),
    );
  }

  void _shortlistApplicant(BuildContext context, WidgetRef ref, Application application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Shortlist Applicant'),
        content: Text('Are you sure you want to shortlist ${_getCreatorName(ref, application.creatorId)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(applicantsProvider(jobId).notifier).shortlistApplication(application.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Applicant shortlisted successfully!')),
                );
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error shortlisting applicant: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Shortlist'),
          ),
        ],
      ),
    );
  }

  void _hireApplicant(BuildContext context, WidgetRef ref, Application application) {
    // Navigate to hire confirmation
    context.push('/listings/jobs/hire/$jobId/${application.id}');
  }

  String _getInitials(WidgetRef ref, String creatorId) {
    final name = _getCreatorName(ref, creatorId);
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  String _getCreatorName(WidgetRef ref, String creatorId) {
    // Get creator name from the application's creator data
    final applicantsState = ref.read(applicantsProvider(jobId));
    return applicantsState.when(
      data: (applicants) {
        final application = applicants.firstWhere((app) => app.creatorId == creatorId);
        return application.creator?.fullName ?? 'Unknown Creator';
      },
      loading: () => 'Loading...',
      error: (_, __) => 'Unknown Creator',
    );
  }

  String _getCreatorHandle(WidgetRef ref, String creatorId) {
    // Get creator handle from the application's creator data
    final applicantsState = ref.read(applicantsProvider(jobId));
    return applicantsState.when(
      data: (applicants) {
        final application = applicants.firstWhere((app) => app.creatorId == creatorId);
        return application.creator?.username ?? 'unknown';
      },
      loading: () => 'loading',
      error: (_, __) => 'unknown',
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}

class _FiltersDialog extends StatefulWidget {
  final ApplicationFilters currentFilters;
  final Function(ApplicationFilters) onFiltersChanged;

  const _FiltersDialog({
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<_FiltersDialog> createState() => _FiltersDialogState();
}

class _FiltersDialogState extends State<_FiltersDialog> {
  late ApplicationFilters _filters;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  late TextEditingController _minRatingController;

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters;
    _minPriceController = TextEditingController(text: _filters.minPrice?.toString() ?? '');
    _maxPriceController = TextEditingController(text: _filters.maxPrice?.toString() ?? '');
    _minRatingController = TextEditingController(text: _filters.minRating?.toString() ?? '');
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minRatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Applicants'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price range
            const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Min Price',
                      prefixText: '\$',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Max Price',
                      prefixText: '\$',
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Rating filter
            const Text('Minimum Rating', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _minRatingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Min Rating',
                suffixText: '/5',
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Verified only
            CheckboxListTile(
              title: const Text('Verified creators only'),
              value: _filters.verifiedOnly,
              onChanged: (value) {
                setState(() {
                  _filters = _filters.copyWith(verifiedOnly: value ?? false);
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Sort by
            const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<ApplicationSortBy>(
              value: _filters.sortBy,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: ApplicationSortBy.values.map((sortBy) {
                return DropdownMenuItem(
                  value: sortBy,
                  child: Text(_getSortByText(sortBy)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _filters = _filters.copyWith(sortBy: value);
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _filters = const ApplicationFilters();
              _minPriceController.clear();
              _maxPriceController.clear();
              _minRatingController.clear();
            });
          },
          child: const Text('Clear All'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final newFilters = _filters.copyWith(
              minPrice: double.tryParse(_minPriceController.text),
              maxPrice: double.tryParse(_maxPriceController.text),
              minRating: double.tryParse(_minRatingController.text),
            );
            widget.onFiltersChanged(newFilters);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  String _getSortByText(ApplicationSortBy sortBy) {
    switch (sortBy) {
      case ApplicationSortBy.recency:
        return 'Most Recent';
      case ApplicationSortBy.rating:
        return 'Highest Rating';
      case ApplicationSortBy.price:
        return 'Lowest Price';
      case ApplicationSortBy.price:
        return 'Lowest Price';
    }
  }
}
