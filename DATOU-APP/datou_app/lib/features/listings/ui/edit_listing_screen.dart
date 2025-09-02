import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/models.dart';
import '../logic/my_listings_provider.dart';

class EditListingScreen extends HookConsumerWidget {
  final String listingId;
  
  const EditListingScreen({
    super.key,
    required this.listingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch listing by ID from provider
    // For now, create a placeholder listing
    final listing = Listing(
      id: listingId,
      creatorId: 'demo-user-1',
      title: 'Edit Listing',
      description: 'This listing is being edited',
      type: ListingType.photography,
      locationText: 'Unknown location',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    final titleController = useTextEditingController(text: listing.title);
    final descriptionController = useTextEditingController(text: listing.description);
    final budgetController = useTextEditingController(text: listing.budget?.toString() ?? '');
    final locationController = useTextEditingController(text: listing.locationText);
    final durationController = useTextEditingController(text: listing.eventDurationHours?.toString() ?? '');
    
    final selectedType = useState<ListingType>(listing.type);
    final isNegotiable = useState<bool>(listing.isNegotiable);
    final isUrgent = useState<bool>(listing.isUrgent);
    final requiredSkills = useState<List<String>>(listing.requiredSkills ?? []);
    final skillController = useTextEditingController();
    
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information
                      _buildSectionTitle('Basic Information'),
                      const SizedBox(height: 16),
                      
                      // Title
                      TextFormField(
                        controller: titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintText: 'Enter listing title',
                          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
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
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Title is required';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Description
                      TextFormField(
                        controller: descriptionController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintText: 'Describe your listing in detail',
                          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
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
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Description is required';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Type Selection
                      _buildSectionTitle('Type'),
                      const SizedBox(height: 16),
                      
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: ListingType.values.map((type) {
                          final isSelected = selectedType.value == type;
                          return GestureDetector(
                            onTap: () => selectedType.value = type,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF8B5CF6) : Colors.grey[700]!,
                                ),
                              ),
                              child: Text(
                                type.name.toUpperCase(),
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Budget and Location
                      _buildSectionTitle('Budget & Location'),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: budgetController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Budget (\$)',
                                labelStyle: const TextStyle(color: Colors.white70),
                                hintText: '0',
                                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
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
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: locationController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Location',
                                labelStyle: const TextStyle(color: Colors.white70),
                                hintText: 'City, State',
                                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
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
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Duration
                      TextFormField(
                        controller: durationController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Duration (hours)',
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintText: '2',
                          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
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
                      
                      const SizedBox(height: 24),
                      
                      // Options
                      _buildSectionTitle('Options'),
                      const SizedBox(height: 16),
                      
                      SwitchListTile(
                        title: const Text(
                          'Budget Negotiable',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          'Allow budget negotiation',
                          style: TextStyle(color: Colors.grey),
                        ),
                        value: isNegotiable.value,
                        onChanged: (value) => isNegotiable.value = value,
                        activeColor: const Color(0xFF8B5CF6),
                      ),
                      
                      SwitchListTile(
                        title: const Text(
                          'Urgent',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          'Mark as urgent listing',
                          style: TextStyle(color: Colors.grey),
                        ),
                        value: isUrgent.value,
                        onChanged: (value) => isUrgent.value = value,
                        activeColor: const Color(0xFF8B5CF6),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Required Skills
                      _buildSectionTitle('Required Skills'),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: skillController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Add Skill',
                                labelStyle: const TextStyle(color: Colors.white70),
                                hintText: 'e.g., Portrait Photography',
                                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
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
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              if (skillController.text.isNotEmpty) {
                                requiredSkills.value = [...requiredSkills.value, skillController.text];
                                skillController.clear();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      if (requiredSkills.value.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: requiredSkills.value.map((skill) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    skill,
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () {
                                      requiredSkills.value = requiredSkills.value
                                          .where((s) => s != skill)
                                          .toList();
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      
                      const SizedBox(height: 32),
                      
                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              // TODO: Implement save functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Listing updated successfully!')),
                              );
                              context.pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              'Edit Listing',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
