import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../../../core/models/models.dart';
import '../../../core/constants.dart';
import '../../../core/theme/app_colors.dart';
import '../logic/my_listings_provider.dart';
import '../logic/listings_providers.dart';
import '../data/listings_repository.dart';
import '../../auth/logic/auth_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/listing_model.dart';

enum CreateListingStep { details, requirements, schedule, payment }

class CreateListingFlow extends HookConsumerWidget {
  const CreateListingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = useState(CreateListingStep.details);
    final pageController = usePageController();
    
    // Store form data across steps
    final listingData = useState<Map<String, dynamic>>({});

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E), // Dark background for better contrast
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
            _buildHeader(context, currentStep.value),
            _buildProgressIndicator(currentStep.value),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  currentStep.value = CreateListingStep.values[index];
                },
                children: [
                  _DetailsStep(
                    onNext: () => _nextStep(pageController, currentStep),
                    onDataUpdate: (data) => listingData.value.addAll(data),
                  ),
                  _RequirementsStep(
                    onNext: () => _nextStep(pageController, currentStep),
                    onBack: () => _previousStep(pageController, currentStep),
                    onDataUpdate: (data) => listingData.value.addAll(data),
                  ),
                  _ScheduleStep(
                    onNext: () => _nextStep(pageController, currentStep),
                    onBack: () => _previousStep(pageController, currentStep),
                    onDataUpdate: (data) => listingData.value.addAll(data),
                  ),
                  _PaymentStep(
                    onBack: () => _previousStep(pageController, currentStep),
                    onComplete: () => _completeListing(context, ref, listingData.value),
                    onDataUpdate: (data) => listingData.value.addAll(data),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CreateListingStep currentStep) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.separator.resolveFrom(context),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Text(
            _getStepTitle(currentStep),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white, // Ensure white text on dark background
            ),
          ),
          const SizedBox(width: 60), // Balance the cancel button
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(CreateListingStep currentStep) {
    final stepIndex = CreateListingStep.values.indexOf(currentStep);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: CreateListingStep.values.asMap().entries.map((entry) {
          final index = entry.key;
          final isActive = index <= stepIndex;
          
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              decoration: BoxDecoration(
                color: isActive ? kPrimary : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _nextStep(PageController pageController, ValueNotifier<CreateListingStep> currentStep) {
    final nextIndex = CreateListingStep.values.indexOf(currentStep.value) + 1;
    if (nextIndex < CreateListingStep.values.length) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep(PageController pageController, ValueNotifier<CreateListingStep> currentStep) {
    final previousIndex = CreateListingStep.values.indexOf(currentStep.value) - 1;
    if (previousIndex >= 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String _getStepTitle(CreateListingStep step) {
    switch (step) {
      case CreateListingStep.details:
        return 'Listing Details';
      case CreateListingStep.requirements:
        return 'Requirements';
      case CreateListingStep.schedule:
        return 'Schedule & Location';
      case CreateListingStep.payment:
        return 'Budget & Payment';
    }
  }

  void _completeListing(BuildContext context, WidgetRef ref, Map<String, dynamic> listingData) async {
    try {
      // Get current user
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be signed in to create a listing'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Validate required fields
      final title = listingData['title']?.toString().trim();
      final description = listingData['description']?.toString().trim();
      final type = listingData['type'] as ListingType?;
      final budget = listingData['budget']?.toString().trim();
      final location = listingData['locationText']?.toString().trim();

      // Check required fields
      if (title == null || title.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Title is required'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (description == null || description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Description is required'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (type == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a listing type'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (budget == null || budget.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Budget is required'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (location == null || location.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location is required'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Ensure user exists in users table (required for foreign key constraint)
      try {
        await Supabase.instance.client
            .from('users')
            .upsert({
              'id': currentUser.id,
              'email': currentUser.email ?? '',
              'full_name': currentUser.userMetadata?['name'] ?? 'User',
              'role': 'photographer',
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }, onConflict: 'id');
      } catch (e) {
        print('Error ensuring user exists: $e');
        // Continue anyway, the listing creation might still work
      }

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF8B5CF6),
          ),
        ),
      );

      // Map enum to string safely (avoid relying on .name)
      String typeString;
      switch (type) {
        case ListingType.photography:
          typeString = 'photography';
          break;
        case ListingType.videography:
          typeString = 'videography';
          break;
        case ListingType.modeling:
          typeString = 'modeling';
          break;
        case ListingType.casting:
          typeString = 'casting';
          break;
      }

      // Create a minimal listing with only essential fields that definitely exist
      final dbListingData = {
        'creator_id': currentUser.id,
        'title': title,
        'description': description,
        'type': typeString,
        'location_text': location,
        'budget': double.tryParse(budget) ?? 0.0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Save the listing to the database using raw insert
      print('Attempting to insert listing with data: $dbListingData');
      final response = await Supabase.instance.client
          .from('listings')
          .insert(dbListingData)
          .select()
          .single();

      print('Listing created successfully: $response');

      var savedListing = Listing.fromJson(response);

      // If user attached images, upload to storage and update the listing with public URLs
      final localImages = (listingData['imageUrls'] as List?)?.cast<String>() ?? [];
      if (localImages.isNotEmpty) {
        try {
          final storage = Supabase.instance.client.storage.from('listing-images');
          final List<String> publicUrls = [];
          for (var i = 0; i < localImages.length; i++) {
            final path = localImages[i];
            final bytes = await File(path).readAsBytes();
            final objectPath = 'listings/${savedListing.id}/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
            await storage.uploadBinary(objectPath, bytes, fileOptions: const FileOptions(upsert: true, contentType: 'image/jpeg'));
            final url = storage.getPublicUrl(objectPath);
            publicUrls.add(url);
          }

          // Update listing with image URLs
          final updated = await Supabase.instance.client
              .from('listings')
              .update({'image_urls': publicUrls})
              .eq('id', savedListing.id)
              .select()
              .single();
          savedListing = Listing.fromJson(updated);
        } catch (e) {
          print('Failed to upload listing images: $e');
        }
      }

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Add the saved listing to My Listings provider
      ref.read(myListingsProvider.notifier).forceAddListing(savedListing);

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing created and saved successfully!'),
            backgroundColor: Color(0xFF8B5CF6),
          ),
        );
      }

      // Navigate to My Listings to show the new listing
      if (context.mounted) {
        Navigator.of(context).pop(); // Close the create flow
        context.push('/my-listings'); // Navigate to My Listings
      }
    } catch (e) {
      // Close loading dialog if it's still open
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create listing: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      print('Error creating listing: $e');
    }
  }
}

class _DetailsStep extends HookConsumerWidget {
  const _DetailsStep({
    required this.onNext,
    required this.onDataUpdate,
  });
  
  final VoidCallback onNext;
  final Function(Map<String, dynamic>) onDataUpdate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final selectedType = useState<ListingType?>(null);
    final selectedImages = useState<List<XFile>>([]);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Required fields note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Color(0xFF8B5CF6),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Fields marked with * are required',
                      style: TextStyle(
                        color: Color(0xFF8B5CF6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'What type of project is this? *',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
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
                      color: isSelected ? kPrimary : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? kPrimary : Colors.grey,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getTypeIcon(type),
                          color: isSelected ? Colors.white : Colors.grey[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getTypeDisplayName(type),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: titleController,
              style: const TextStyle(color: Colors.white), // White text for input
              decoration: InputDecoration(
                labelText: 'Project Title *',
                labelStyle: const TextStyle(color: Colors.white70), // White label
                hintText: 'Enter a descriptive title for your project',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)), // Grey hint
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
                fillColor: const Color(0xFF374151), // Dark fill for better contrast
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white), // White text for input
              decoration: InputDecoration(
                labelText: 'Description *',
                labelStyle: const TextStyle(color: Colors.white70), // White label
                hintText: 'Describe your project requirements, style, and expectations...',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)), // Grey hint
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
                fillColor: const Color(0xFF374151), // Dark fill for better contrast
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'Project Images (Optional)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // White text for visibility
                  ),
                ),
                const Spacer(),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _pickImages(selectedImages),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.camera),
                      SizedBox(width: 4),
                      Text('Add Photos'),
                    ],
                  ),
                ),
              ],
            ),
            if (selectedImages.value.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(selectedImages.value[index].path),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image);
                              },
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                final newImages = List<XFile>.from(selectedImages.value);
                                newImages.removeAt(index);
                                selectedImages.value = newImages;
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    if (selectedType.value != null) {
                      // Collect data before moving to next step
                      final data = {
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'type': selectedType.value,
                        'imageUrls': selectedImages.value.map((img) => img.path).toList(),
                      };
                      onDataUpdate(data);
                      onNext();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a project type')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages(ValueNotifier<List<XFile>> selectedImages) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    selectedImages.value = [...selectedImages.value, ...images];
  }

  IconData _getTypeIcon(ListingType type) {
    switch (type) {
      case ListingType.photography:
        return Icons.camera_alt;
      case ListingType.videography:
        return Icons.videocam;
      case ListingType.modeling:
        return Icons.person;
      case ListingType.casting:
        return Icons.group;
    }
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

  static String _getListingTypeString(ListingType type) {
    switch (type) {
      case ListingType.photography:
        return 'photography';
      case ListingType.videography:
        return 'videography';
      case ListingType.modeling:
        return 'modeling';
      case ListingType.casting:
        return 'casting';
    }
  }

  static String _getListingStatusString(ListingStatus status) {
    switch (status) {
      case ListingStatus.draft:
        return 'draft';
      case ListingStatus.active:
        return 'active';
      case ListingStatus.paused:
        return 'paused';
      case ListingStatus.completed:
        return 'completed';
      case ListingStatus.cancelled:
        return 'cancelled';
    }
  }
}

class _RequirementsStep extends HookConsumerWidget {
  const _RequirementsStep({
    required this.onNext,
    required this.onBack,
    required this.onDataUpdate,
  });
  
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Function(Map<String, dynamic>) onDataUpdate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRole = useState<UserRole?>(null);
    final experienceYears = useState<int?>(null);
    final requiredSkills = useState<List<String>>([]);
    final skillController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Who are you looking for?',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w600,
              color: Colors.white, // White text for visibility
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: UserRole.values.map((role) {
              final isSelected = selectedRole.value == role;
              return GestureDetector(
                onTap: () => selectedRole.value = role,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimary : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? kPrimary : Colors.grey,
                    ),
                  ),
                  child: Text(
                    _getRoleDisplayName(role),
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
          const Text(
            'Experience Level',
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w600,
              color: Colors.white, // White text for visibility
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: experienceYears.value,
            style: const TextStyle(color: Colors.white), // White text for input
            dropdownColor: const Color(0xFF2A2A2A), // Dark dropdown background
            decoration: InputDecoration(
              hintText: 'Select minimum years of experience',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)), // Grey hint
              labelStyle: const TextStyle(color: Colors.white70), // White label
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
              fillColor: const Color(0xFF374151), // Dark fill for better contrast
            ),
            items: [
              DropdownMenuItem(value: 0, child: Text('Any experience level', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: 1, child: Text('1+ years', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: 3, child: Text('3+ years', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: 5, child: Text('5+ years', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: 10, child: Text('10+ years', style: TextStyle(color: Colors.white))),
            ],
            onChanged: (value) => experienceYears.value = value,
          ),
          const SizedBox(height: 24),
          const Text(
            'Required Skills/Equipment',
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w600,
              color: Colors.white, // White text for visibility
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: skillController,
                  style: const TextStyle(color: Colors.white), // White text for input
                  decoration: InputDecoration(
                    hintText: 'Enter a skill or equipment requirement',
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)), // Grey hint
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
                    fillColor: const Color(0xFF374151), // Dark fill for better contrast
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final skill = skillController.text.trim();
                  if (skill.isNotEmpty && !requiredSkills.value.contains(skill)) {
                    requiredSkills.value = [...requiredSkills.value, skill];
                    skillController.clear();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
          if (requiredSkills.value.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: requiredSkills.value.map((skill) {
                return Chip(
                  label: Text(skill),
                  onDeleted: () {
                    requiredSkills.value = requiredSkills.value
                        .where((s) => s != skill)
                        .toList();
                  },
                );
              }).toList(),
            ),
          ],
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Collect data before moving to next step
                    final data = {
                      'requiredRole': selectedRole.value,
                      'experienceYears': experienceYears.value,
                      'requiredSkills': requiredSkills.value,
                    };
                    onDataUpdate(data);
                    onNext();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

class _ScheduleStep extends HookConsumerWidget {
  const _ScheduleStep({
    required this.onNext,
    required this.onBack,
    required this.onDataUpdate,
  });
  
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Function(Map<String, dynamic>) onDataUpdate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = useState<DateTime?>(null);
    final durationHours = useState<int?>(null);
    final locationController = useTextEditingController();
    final applicationDeadline = useState<DateTime?>(null);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'When and where?',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w600,
              color: Colors.white, // White text for visibility
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: locationController,
            style: const TextStyle(color: Colors.white), // White text for input
            decoration: InputDecoration(
              labelText: 'Location *',
              labelStyle: const TextStyle(color: Colors.white70), // White label
              hintText: 'Enter the event location',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)), // Grey hint
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
              fillColor: const Color(0xFF374151), // Dark fill for better contrast
              prefixIcon: const Icon(Icons.location_on, color: Color(0xFF9CA3AF)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selectDate(context, selectedDate),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    selectedDate.value != null
                        ? '${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}'
                        : 'Select Event Date',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: durationHours.value,
                  style: const TextStyle(color: Colors.white), // White text for input
                  dropdownColor: const Color(0xFF2A2A2A), // Dark dropdown background
                  decoration: InputDecoration(
                    hintText: 'Duration (hours)',
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)), // Grey hint
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
                    fillColor: const Color(0xFF374151), // Dark fill for better contrast
                  ),
                  items: List.generate(12, (index) {
                    final hours = index + 1;
                    return DropdownMenuItem(
                      value: hours,
                      child: Text(
                        '$hours hour${hours > 1 ? 's' : ''}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }),
                  onChanged: (value) => durationHours.value = value,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Application Deadline',
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w600,
              color: Colors.white, // White text for visibility
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _selectDate(context, applicationDeadline),
            icon: const Icon(Icons.schedule),
            label: Text(
              applicationDeadline.value != null
                  ? '${applicationDeadline.value!.day}/${applicationDeadline.value!.month}/${applicationDeadline.value!.year}'
                  : 'Select Application Deadline',
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Collect data before moving to next step
                    final data = {
                      'eventDate': selectedDate.value,
                      'durationHours': durationHours.value,
                      'locationText': locationController.text,
                      'applicationDeadline': applicationDeadline.value,
                    };
                    onDataUpdate(data);
                    onNext();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, ValueNotifier<DateTime?> dateNotifier) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      dateNotifier.value = date;
    }
  }
}

class _PaymentStep extends HookConsumerWidget {
  const _PaymentStep({
    required this.onBack,
    required this.onComplete,
    required this.onDataUpdate,
  });
  
  final VoidCallback onBack;
  final VoidCallback onComplete;
  final Function(Map<String, dynamic>) onDataUpdate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetController = useTextEditingController();
    final isNegotiable = useState(true);
    final isUrgent = useState(false);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget & Payment',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w600,
              color: Colors.white, // White text for visibility
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white), // White text for input
            decoration: InputDecoration(
              labelText: 'Budget *',
              labelStyle: const TextStyle(color: Colors.white70), // White label
              hintText: 'Enter your budget amount',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)), // Grey hint
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
              fillColor: const Color(0xFF374151), // Dark fill for better contrast
              prefixText: '\$',
              prefixStyle: const TextStyle(color: Colors.white), // White prefix text
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text(
              'Budget is negotiable',
              style: TextStyle(color: Colors.white), // White text for visibility
            ),
            subtitle: const Text(
              'Allow professionals to propose different rates',
              style: TextStyle(color: Color(0xFFD1D5DB)), // Light grey text for visibility
            ),
            value: isNegotiable.value,
            onChanged: (value) => isNegotiable.value = value,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text(
              'Mark as urgent',
              style: TextStyle(color: Colors.white), // White text for visibility
            ),
            subtitle: const Text(
              'This will boost your listing visibility',
              style: TextStyle(color: Color(0xFFD1D5DB)), // Light grey text for visibility
            ),
            value: isUrgent.value,
            onChanged: (value) => isUrgent.value = value,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Protection',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // White text for visibility
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your payment will be held securely until the work is completed. '
                  'A 5% platform fee will be added to the final amount.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFD1D5DB), // Light grey text for visibility
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Collect budget data before completing
                    final budgetData = {
                      'budget': budgetController.text.trim(),
                      'isNegotiable': isNegotiable.value,
                      'isUrgent': isUrgent.value,
                    };
                    onDataUpdate(budgetData);
                    
                    // TODO: Save listing and create payment intent
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Listing created successfully!'),
                      ),
                    );
                    onComplete();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Create Listing'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}