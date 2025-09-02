import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/job_models.dart';
import '../viewmodels/jobs_feed_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/glass_container.dart';

class HireConfirmationView extends HookConsumerWidget {
  final String jobId;
  final String? applicationId;

  const HireConfirmationView({
    super.key,
    required this.jobId,
    this.applicationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobState = ref.watch(jobDetailProvider(jobId));
    final applicationState = applicationId != null 
        ? ref.watch(applicantsProvider(jobId)).when(
            data: (applications) => applications.where((app) => app.id == applicationId).firstOrNull,
            loading: () => null,
            error: (_, __) => null,
          )
        : null;
    
    // Form controllers
    final agreedAmountController = useTextEditingController();
    final agreedTermsController = useTextEditingController();
    final milestonesController = useTextEditingController();
    final dueDateController = useTextEditingController();
    final paymentScheduleController = useTextEditingController();
    final licenseTermsController = useTextEditingController();
    
    // Initialize form with application data
    useEffect(() {
      if (applicationState != null) {
        agreedAmountController.text = applicationState.proposedAmount.toString();
        agreedTermsController.text = applicationState.proposedTerms ?? '';
        milestonesController.text = '50% upfront, 50% upon completion';
        dueDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 21)));
        paymentScheduleController.text = 'Net 30 days';
        licenseTermsController.text = 'Exclusive rights for commercial use';
      }
      return null;
    }, [applicationState]);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Confirm Hire',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job and Application Info
            jobState.when(
              data: (job) {
                if (job == null) return const SizedBox.shrink();
                return _buildJobInfo(context, job);
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
              ),
              error: (error, stack) => Center(
                child: Text(
                  'Error loading job: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Application Details
            if (applicationState != null) ...[
              _buildApplicationInfo(context, ref, applicationState),
              const SizedBox(height: 24),
            ],
            
            // Contract Terms Form
            _buildContractTermsForm(
              context,
              agreedAmountController,
              agreedTermsController,
              milestonesController,
              dueDateController,
              paymentScheduleController,
              licenseTermsController,
            ),
            
            const SizedBox(height: 24),
            
            // Confirmation Actions
            _buildConfirmationActions(
              context,
              ref,
              agreedAmountController,
              agreedTermsController,
              milestonesController,
              dueDateController,
              paymentScheduleController,
              licenseTermsController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobInfo(BuildContext context, Job job) {
    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job Details',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              job.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
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
    );
  }

  Widget _buildApplicationInfo(BuildContext context, WidgetRef ref, Application application) {
    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
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
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Proposal',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
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
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildProposalDetail('Proposed Price', '\$${application.proposedAmount}'),
                const SizedBox(width: 16),
                _buildProposalDetail('Submitted', _formatDate(application.createdAt)),
              ],
            ),
          ],
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

  Widget _buildContractTermsForm(
    BuildContext context,
    TextEditingController agreedAmountController,
    TextEditingController agreedTermsController,
    TextEditingController milestonesController,
    TextEditingController dueDateController,
    TextEditingController paymentScheduleController,
    TextEditingController licenseTermsController,
  ) {
    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contract Terms',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Agreed Amount
            _buildFormField(
              controller: agreedAmountController,
              label: 'Agreed Amount',
              prefix: '\$',
              keyboardType: TextInputType.number,
            ),
            
            const SizedBox(height: 16),
            
            // Agreed Terms
            _buildFormField(
              controller: agreedTermsController,
              label: 'Agreed Terms',
              maxLines: 3,
            ),
            
            const SizedBox(height: 16),
            
            // Milestones
            _buildFormField(
              controller: milestonesController,
              label: 'Payment Milestones',
              maxLines: 2,
            ),
            
            const SizedBox(height: 16),
            
            // Due Date
            _buildFormField(
              controller: dueDateController,
              label: 'Project Due Date',
              suffix: 'YYYY-MM-DD',
            ),
            
            const SizedBox(height: 16),
            
            // Payment Schedule
            _buildFormField(
              controller: paymentScheduleController,
              label: 'Payment Schedule',
            ),
            
            const SizedBox(height: 16),
            
            // License Terms
            _buildFormField(
              controller: licenseTermsController,
              label: 'License Terms',
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    String? prefix,
    String? suffix,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixText: prefix,
            suffixText: suffix,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4B5563)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4B5563)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF8B5CF6)),
            ),
            filled: true,
            fillColor: const Color(0xFF374151),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationActions(
    BuildContext context,
    WidgetRef ref,
    TextEditingController agreedAmountController,
    TextEditingController agreedTermsController,
    TextEditingController milestonesController,
    TextEditingController dueDateController,
    TextEditingController paymentScheduleController,
    TextEditingController licenseTermsController,
  ) {
    return Column(
      children: [
        // Terms and Conditions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info, color: Colors.blue[300], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'By confirming this hire, you agree to the terms outlined above. A contract will be created and the job status will be updated to "Hiring".',
                style: TextStyle(
                  color: Colors.blue[200],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _confirmHire(
                  context,
                  ref,
                  agreedAmountController,
                  agreedTermsController,
                  milestonesController,
                  dueDateController,
                  paymentScheduleController,
                  licenseTermsController,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Confirm Hire'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _confirmHire(
    BuildContext context,
    WidgetRef ref,
    TextEditingController agreedAmountController,
    TextEditingController agreedTermsController,
    TextEditingController milestonesController,
    TextEditingController dueDateController,
    TextEditingController paymentScheduleController,
    TextEditingController licenseTermsController,
  ) {
    final agreedAmount = int.tryParse(agreedAmountController.text);
    if (agreedAmount == null || agreedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid agreed amount')),
      );
      return;
    }

    if (agreedTermsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter agreed terms')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Hire'),
        content: const Text(
          'Are you sure you want to hire this creator? This action will create a contract and update the job status.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              try {
                // Combine all terms into a comprehensive agreement
                final comprehensiveTerms = '''
Agreed Amount: \$${agreedAmountController.text}
Agreed Terms: ${agreedTermsController.text}
Payment Milestones: ${milestonesController.text}
Due Date: ${dueDateController.text}
Payment Schedule: ${paymentScheduleController.text}
License Terms: ${licenseTermsController.text}
                '''.trim();

                if (applicationId != null) {
                  await ref.read(applicantsProvider(jobId).notifier).hireApplication(
                    applicationId!,
                    agreedAmount,
                    comprehensiveTerms,
                  );
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hire confirmed successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );

                // Navigate back to job management
                context.pop();
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error confirming hire: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
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
