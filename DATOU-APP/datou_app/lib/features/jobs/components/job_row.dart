import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/job_models.dart';

class JobRow extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;
  final bool showStatus;

  const JobRow({
    super.key,
    required this.job,
    this.onTap,
    this.showStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 2,
      shadowColor: colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  if (showStatus) ...[
                    _StatusBadge(status: job.status),
                    const SizedBox(width: 12),
                  ],
                  
                  // Title and Budget
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              job.budgetDisplay,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Location Badge
                  _LocationBadge(locationType: job.locationType),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Description
              Text(
                job.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 16),
              
              // Requirements Preview
              if (job.requirements.isNotEmpty) ...[
                _RequirementsPreview(requirements: job.requirements),
                const SizedBox(height: 16),
              ],
              
              // Footer Row
              Row(
                children: [
                  // Timeline
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _formatTimeline(job.timelineStart, job.timelineEnd),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Posted Date
                  Text(
                    _formatPostedDate(job.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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

  String _formatTimeline(DateTime start, DateTime end) {
    final startFormatted = DateFormat('MMM d').format(start);
    final endFormatted = DateFormat('MMM d').format(end);
    
    if (start.year == end.year) {
      if (start.month == end.month) {
        return '$startFormatted - ${DateFormat('d, y').format(end)}';
      } else {
        return '$startFormatted - ${DateFormat('MMM d, y').format(end)}';
      }
    } else {
      return '${DateFormat('MMM d, y').format(start)} - ${DateFormat('MMM d, y').format(end)}';
    }
  }

  String _formatPostedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
}

// MARK: - Status Badge
class _StatusBadge extends StatelessWidget {
  final JobStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    Color backgroundColor;
    Color textColor;
    IconData icon;
    
    switch (status) {
      case JobStatus.open:
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green.shade700;
        icon = Icons.work_outline;
        break;
      case JobStatus.hiring:
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue.shade700;
        icon = Icons.people_outline;
        break;
      case JobStatus.closed:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey.shade700;
        icon = Icons.lock_outline;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: textColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: - Location Badge
class _LocationBadge extends StatelessWidget {
  final LocationType locationType;

  const _LocationBadge({required this.locationType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.secondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            IconData(
              _getLocationIconCode(locationType),
              fontFamily: 'MaterialIcons',
            ),
            size: 12,
            color: colorScheme.secondary,
          ),
          const SizedBox(width: 4),
          Text(
            locationType.displayName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  int _getLocationIconCode(LocationType type) {
    switch (type) {
      case LocationType.remote:
        return 0xe5c9; // laptop
      case LocationType.onsite:
        return 0xe55f; // location_on
      case LocationType.hybrid:
        return 0xe6b8; // sync
    }
  }
}

// MARK: - Requirements Preview
class _RequirementsPreview extends StatelessWidget {
  final Map<String, dynamic> requirements;

  const _RequirementsPreview({required this.requirements});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final skills = requirements['skills'] as List<dynamic>? ?? [];
    final gear = requirements['gear'] as List<dynamic>? ?? [];
    
    if (skills.isEmpty && gear.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Skills
        if (skills.isNotEmpty) ...[
          ...skills.take(3).map((skill) => _RequirementChip(
            label: skill.toString(),
            icon: Icons.star,
            color: colorScheme.primary,
          )),
          if (skills.length > 3)
            _RequirementChip(
              label: '+${skills.length - 3} more',
              icon: Icons.more_horiz,
              color: colorScheme.onSurfaceVariant,
            ),
        ],
        
        // Gear
        if (gear.isNotEmpty) ...[
          ...gear.take(2).map((item) => _RequirementChip(
            label: item.toString(),
            icon: Icons.camera_alt,
            color: colorScheme.secondary,
          )),
          if (gear.length > 2)
            _RequirementChip(
              label: '+${gear.length - 2} more',
              icon: Icons.more_horiz,
              color: colorScheme.onSurfaceVariant,
            ),
        ],
      ],
    );
  }
}

// MARK: - Requirement Chip
class _RequirementChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _RequirementChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: - Preview
class JobRowPreview extends StatelessWidget {
  const JobRowPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            JobRow(
              job: JobMock.mock,
              onTap: () => print('Job tapped'),
            ),
            const SizedBox(height: 16),
            JobRow(
              job: JobMock.mockList[1],
              onTap: () => print('Job tapped'),
            ),
            const SizedBox(height: 16),
            JobRow(
              job: JobMock.mockList[2],
              onTap: () => print('Job tapped'),
            ),
          ],
        ),
      ),
    );
  }
}
