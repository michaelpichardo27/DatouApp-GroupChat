import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/models/models.dart';
import '../../../../core/constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../logic/listings_providers.dart';

class ListingsFilterBar extends ConsumerStatefulWidget {
  const ListingsFilterBar({super.key});

  @override
  ConsumerState<ListingsFilterBar> createState() => _ListingsFilterBarState();
}

class _ListingsFilterBarState extends ConsumerState<ListingsFilterBar> {
  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(listingsFiltersProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Filter button with all options
              Expanded(
                child: GestureDetector(
                  onTap: () => _showAdvancedFilters(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _hasActiveFilters(filters) 
                          ? kPrimary.withOpacity(0.1) 
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _hasActiveFilters(filters) 
                            ? kPrimary.withOpacity(0.3) 
                            : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.tune,
                          color: _hasActiveFilters(filters) ? kPrimary : Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getFilterButtonText(filters),
                          style: TextStyle(
                            color: _hasActiveFilters(filters) ? kPrimary : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        if (_hasActiveFilters(filters))
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: kPrimary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _getActiveFilterCount(filters).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Show active filters as removable chips
          if (_hasActiveFilters(filters)) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (filters.types.isNotEmpty)
                  ...filters.types.map(
                    (type) => _buildActiveFilterChip(
                      _getTypeDisplayName(type),
                      () => _removeTypeFilter(type),
                    ),
                  ),
                if (filters.urgentOnly)
                  _buildActiveFilterChip(
                    'Urgent Only',
                    () => _updateIsUrgentFilter(false),
                  ),
                if (filters.roles.isNotEmpty)
                  ...filters.roles.map(
                    (role) => _buildActiveFilterChip(
                      _getRoleDisplayName(role),
                      () => _removeRoleFilter(role),
                    ),
                  ),
                if (filters.locationSearch?.isNotEmpty == true)
                  _buildActiveFilterChip(
                    'Location: ${filters.locationSearch}',
                    () => _updateLocationFilter(null),
                  ),
                if (filters.minBudget != null || filters.maxBudget != null)
                  _buildActiveFilterChip(
                    _getBudgetFilterText(filters),
                    () => _updateBudgetFilters(null, null),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kPrimary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: kPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 16,
              color: kPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _getFilterButtonText(ListingFilters filters) {
    if (_hasActiveFilters(filters)) {
      return 'Filters Applied';
    }
    return 'Filter Listings';
  }

  int _getActiveFilterCount(ListingFilters filters) {
    int count = 0;
    if (filters.types.isNotEmpty) count += filters.types.length;
    if (filters.urgentOnly) count += 1;
    if (filters.roles.isNotEmpty) count += filters.roles.length;
    if (filters.locationSearch?.isNotEmpty == true) count += 1;
    if (filters.minBudget != null || filters.maxBudget != null) count += 1;
    return count;
  }

  String _getBudgetFilterText(ListingFilters filters) {
    if (filters.minBudget != null && filters.maxBudget != null) {
      return '\$${filters.minBudget!.toInt()} - \$${filters.maxBudget!.toInt()}';
    } else if (filters.minBudget != null) {
      return 'Min: \$${filters.minBudget!.toInt()}';
    } else if (filters.maxBudget != null) {
      return 'Max: \$${filters.maxBudget!.toInt()}';
    }
    return 'Budget';
  }

  void _removeTypeFilter(ListingType type) {
    final currentFilters = ref.read(listingsFiltersProvider);
    final newTypes = currentFilters.types.where((t) => t != type).toList();
    _updateTypeFilters(newTypes);
  }

  void _updateTypeFilters(List<ListingType> types) {
    final currentFilters = ref.read(listingsFiltersProvider);
    ref.read(listingsFiltersProvider.notifier).state = 
        currentFilters.copyWith(types: types);
    ref.read(listingsProvider.notifier).refresh();
  }

  void _removeRoleFilter(UserRole role) {
    final currentFilters = ref.read(listingsFiltersProvider);
    final newRoles = currentFilters.roles.where((r) => r != role).toList();
    ref.read(listingsFiltersProvider.notifier).state = 
        currentFilters.copyWith(roles: newRoles);
    ref.read(listingsProvider.notifier).refresh();
  }

  void _updateIsUrgentFilter(bool? isUrgent) {
    final currentFilters = ref.read(listingsFiltersProvider);
    ref.read(listingsFiltersProvider.notifier).state = 
        currentFilters.copyWith(urgentOnly: isUrgent ?? false);
    ref.read(listingsProvider.notifier).refresh();
  }

  void _updateLocationFilter(String? location) {
    final currentFilters = ref.read(listingsFiltersProvider);
    ref.read(listingsFiltersProvider.notifier).state = 
        currentFilters.copyWith(locationSearch: location);
    ref.read(listingsProvider.notifier).refresh();
  }

  void _updateBudgetFilters(double? minBudget, double? maxBudget) {
    final currentFilters = ref.read(listingsFiltersProvider);
    ref.read(listingsFiltersProvider.notifier).state = 
        currentFilters.copyWith(minBudget: minBudget, maxBudget: maxBudget);
    ref.read(listingsProvider.notifier).refresh();
  }

  bool _hasActiveFilters(ListingFilters filters) {
    return filters.types.isNotEmpty ||
           filters.roles.isNotEmpty ||
           filters.minBudget != null ||
           filters.maxBudget != null ||
           filters.locationSearch?.isNotEmpty == true ||
           filters.urgentOnly;
  }

  void _showAdvancedFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _AdvancedFiltersSheet(),
    );
  }

  String _getTypeDisplayName(ListingType type) {
    switch (type) {
      case ListingType.photography:
        return 'Photography';
      case ListingType.videography:
        return 'Videography';
      case ListingType.modeling:
        return 'Modeling';
      case ListingType.casting:
        return 'Casting';
    }
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.photographer:
        return 'Photographer';
      case UserRole.videographer:
        return 'Videographer';
      case UserRole.model:
        return 'Model';
      case UserRole.agency:
        return 'Agency';
    }
  }
}

class _AdvancedFiltersSheet extends ConsumerStatefulWidget {
  const _AdvancedFiltersSheet();

  @override
  ConsumerState<_AdvancedFiltersSheet> createState() => _AdvancedFiltersSheetState();
}

class _AdvancedFiltersSheetState extends ConsumerState<_AdvancedFiltersSheet> {
  late ListingFilters _tempFilters;
  final _locationController = TextEditingController();
  final _minBudgetController = TextEditingController();
  final _maxBudgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tempFilters = ref.read(listingsFiltersProvider);
    _locationController.text = _tempFilters.location ?? '';
    _minBudgetController.text = _tempFilters.minBudget?.toString() ?? '';
    _maxBudgetController.text = _tempFilters.maxBudget?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Listings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Listing Types Section
          const Text('Listing Types', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildTypeChip('All Types', _tempFilters.types.isEmpty, () {
                setState(() {
                  _tempFilters = _tempFilters.copyWith(types: []);
                });
              }),
              ...ListingType.values.map((type) => _buildTypeChip(
                _getTypeDisplayName(type),
                _tempFilters.types.contains(type),
                () {
                  setState(() {
                    final newTypes = _tempFilters.types.contains(type)
                        ? _tempFilters.types.where((t) => t != type).toList()
                        : [..._tempFilters.types, type];
                    _tempFilters = _tempFilters.copyWith(types: newTypes);
                  });
                },
              )),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Required Role Section
          const Text('Required Role', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: UserRole.values.map((role) {
              final isSelected = _tempFilters.roles.contains(role);
              return FilterChip(
                label: Text(_getRoleDisplayName(role)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _tempFilters = _tempFilters.copyWith(
                        roles: [..._tempFilters.roles, role],
                      );
                    } else {
                      _tempFilters = _tempFilters.copyWith(
                        roles: _tempFilters.roles.where((r) => r != role).toList(),
                      );
                    }
                  });
                },
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // Location Section
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
              hintText: 'Enter city or area',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              _tempFilters = _tempFilters.copyWith(locationSearch: value.isEmpty ? null : value);
            },
          ),
          
          const SizedBox(height: 16),
          
          // Budget Section
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minBudgetController,
                  decoration: const InputDecoration(
                    labelText: 'Min Budget',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final budget = double.tryParse(value);
                    _tempFilters = _tempFilters.copyWith(minBudget: budget);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _maxBudgetController,
                  decoration: const InputDecoration(
                    labelText: 'Max Budget',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final budget = double.tryParse(value);
                    _tempFilters = _tempFilters.copyWith(maxBudget: budget);
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Urgent Only Toggle
          SwitchListTile(
            title: const Text('Urgent only'),
            value: _tempFilters.urgentOnly,
            onChanged: (value) {
              setState(() {
                _tempFilters = _tempFilters.copyWith(urgentOnly: value);
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _tempFilters = const ListingFilters();
                      _locationController.clear();
                      _minBudgetController.clear();
                      _maxBudgetController.clear();
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(listingsFiltersProvider.notifier).state = _tempFilters;
                    ref.read(listingsProvider.notifier).refresh();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kPrimary : Colors.grey.withOpacity(0.5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _getTypeDisplayName(ListingType type) {
    switch (type) {
      case ListingType.photography:
        return 'Photography';
      case ListingType.videography:
        return 'Videography';
      case ListingType.modeling:
        return 'Modeling';
      case ListingType.casting:
        return 'Casting';
    }
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.photographer:
        return 'Photographer';
      case UserRole.videographer:
        return 'Videographer';
      case UserRole.model:
        return 'Model';
      case UserRole.agency:
        return 'Agency';
    }
  }
}