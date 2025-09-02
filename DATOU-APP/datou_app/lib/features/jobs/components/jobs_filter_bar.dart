import 'package:flutter/material.dart';
import '../models/job_models.dart';

class JobsFilterBar extends StatelessWidget {
  final JobStatus? selectedStatus;
  final LocationType? selectedLocationType;
  final int? minBudget;
  final int? maxBudget;
  final ValueChanged<JobStatus?> onStatusChanged;
  final ValueChanged<LocationType?> onLocationTypeChanged;
  final ValueChanged<(int?, int?)> onBudgetChanged;
  final VoidCallback onClearFilters;

  const JobsFilterBar({
    super.key,
    this.selectedStatus,
    this.selectedLocationType,
    this.minBudget,
    this.maxBudget,
    required this.onStatusChanged,
    required this.onLocationTypeChanged,
    required this.onBudgetChanged,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final hasActiveFilters = selectedStatus != null ||
                            selectedLocationType != null ||
                            minBudget != null ||
                            maxBudget != null;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Status Filters
          Expanded(
            child: _StatusFilterSection(
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Location Type Filters
          Expanded(
            child: _LocationTypeFilterSection(
              selectedLocationType: selectedLocationType,
              onLocationTypeChanged: onLocationTypeChanged,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Budget Filter Button
          _BudgetFilterButton(
            minBudget: minBudget,
            maxBudget: maxBudget,
            onBudgetChanged: onBudgetChanged,
          ),
          
          // Clear Filters Button
          if (hasActiveFilters) ...[
            const SizedBox(width: 8),
            _ClearFiltersButton(onClearFilters: onClearFilters),
          ],
        ],
      ),
    );
  }
}

// MARK: - Status Filter Section
class _StatusFilterSection extends StatelessWidget {
  final JobStatus? selectedStatus;
  final ValueChanged<JobStatus?> onStatusChanged;

  const _StatusFilterSection({
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: selectedStatus == null,
            onTap: () => onStatusChanged(null),
          ),
          const SizedBox(width: 8),
          ...JobStatus.values.map((status) => Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _FilterChip(
              label: status.displayName,
              isSelected: selectedStatus == status,
              onTap: () => onStatusChanged(status),
              color: _getStatusColor(status),
            ),
          )),
        ],
      ),
    );
  }

  Color _getStatusColor(JobStatus status) {
    switch (status) {
      case JobStatus.open:
        return Colors.green;
      case JobStatus.hiring:
        return Colors.blue;
      case JobStatus.closed:
        return Colors.grey;
    }
  }
}

// MARK: - Location Type Filter Section
class _LocationTypeFilterSection extends StatelessWidget {
  final LocationType? selectedLocationType;
  final ValueChanged<LocationType?> onLocationTypeChanged;

  const _LocationTypeFilterSection({
    required this.selectedLocationType,
    required this.onLocationTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: selectedLocationType == null,
            onTap: () => onLocationTypeChanged(null),
          ),
          const SizedBox(width: 8),
          ...LocationType.values.map((type) => Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _FilterChip(
              label: type.displayName,
              isSelected: selectedLocationType == type,
              onTap: () => onLocationTypeChanged(type),
              icon: _getLocationIcon(type),
            ),
          )),
        ],
      ),
    );
  }

  IconData _getLocationIcon(LocationType type) {
    switch (type) {
      case LocationType.remote:
        return Icons.laptop;
      case LocationType.onsite:
        return Icons.location_on;
      case LocationType.hybrid:
        return Icons.sync;
    }
  }
}

// MARK: - Budget Filter Button
class _BudgetFilterButton extends StatelessWidget {
  final int? minBudget;
  final int? maxBudget;
  final ValueChanged<(int?, int?)> onBudgetChanged;

  const _BudgetFilterButton({
    required this.minBudget,
    required this.maxBudget,
    required this.onBudgetChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final hasBudgetFilter = minBudget != null || maxBudget != null;
    
    return InkWell(
      onTap: () => _showBudgetDialog(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: hasBudgetFilter 
              ? colorScheme.primary.withOpacity(0.1)
              : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasBudgetFilter 
                ? colorScheme.primary.withOpacity(0.3)
                : colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.attach_money,
              size: 16,
              color: hasBudgetFilter ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              hasBudgetFilter ? _getBudgetLabel() : 'Budget',
              style: theme.textTheme.labelMedium?.copyWith(
                color: hasBudgetFilter ? colorScheme.primary : colorScheme.onSurfaceVariant,
                fontWeight: hasBudgetFilter ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBudgetLabel() {
    if (minBudget != null && maxBudget != null) {
      return '\$${minBudget}k-\$${maxBudget}k';
    } else if (minBudget != null) {
      return '>\$${minBudget}k';
    } else if (maxBudget != null) {
      return '<\$${maxBudget}k';
    }
    return 'Budget';
  }

  void _showBudgetDialog(BuildContext context) {
    final minController = TextEditingController(text: minBudget?.toString() ?? '');
    final maxController = TextEditingController(text: maxBudget?.toString() ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Budget Range'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: minController,
              decoration: const InputDecoration(
                labelText: 'Minimum Budget (\$k)',
                hintText: 'e.g., 500',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: maxController,
              decoration: const InputDecoration(
                labelText: 'Maximum Budget (\$k)',
                hintText: 'e.g., 2000',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final min = int.tryParse(minController.text);
              final max = int.tryParse(maxController.text);
              
              if (min != null && max != null && min > max) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Minimum budget cannot be greater than maximum')),
                );
                return;
              }
              
              onBudgetChanged((min, max));
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

// MARK: - Clear Filters Button
class _ClearFiltersButton extends StatelessWidget {
  final VoidCallback onClearFilters;

  const _ClearFiltersButton({required this.onClearFilters});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return InkWell(
      onTap: onClearFilters,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.error.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.clear,
              size: 16,
              color: colorScheme.error,
            ),
            const SizedBox(width: 4),
            Text(
              'Clear',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MARK: - Filter Chip
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;
  final IconData? icon;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final chipColor = color ?? colorScheme.primary;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? chipColor.withOpacity(0.2)
              : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? chipColor.withOpacity(0.5)
                : colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? chipColor : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected ? chipColor : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MARK: - Preview
class JobsFilterBarPreview extends StatelessWidget {
  const JobsFilterBarPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            JobsFilterBar(
              selectedStatus: JobStatus.open,
              selectedLocationType: LocationType.onsite,
              minBudget: 500,
              maxBudget: 2000,
              onStatusChanged: (status) => print('Status: $status'),
              onLocationTypeChanged: (type) => print('Location: $type'),
              onBudgetChanged: (budget) => print('Budget: $budget'),
              onClearFilters: () => print('Clear filters'),
            ),
            const SizedBox(height: 32),
            JobsFilterBar(
              selectedStatus: null,
              selectedLocationType: null,
              minBudget: null,
              maxBudget: null,
              onStatusChanged: (status) => print('Status: $status'),
              onLocationTypeChanged: (type) => print('Location: $type'),
              onBudgetChanged: (budget) => print('Budget: $budget'),
              onClearFilters: () => print('Clear filters'),
            ),
          ],
        ),
      ),
    );
  }
}
