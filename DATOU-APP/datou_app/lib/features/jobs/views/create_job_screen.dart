import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/job_models.dart';
import '../viewmodels/jobs_feed_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/glass_container.dart';

class CreateJobScreen extends HookConsumerWidget {
  const CreateJobScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Form controllers
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final budgetMinController = useTextEditingController();
    final budgetMaxController = useTextEditingController();
    final timelineStartController = useTextEditingController();
    final timelineEndController = useTextEditingController();
    final locationCityController = useTextEditingController();
    final locationRegionController = useTextEditingController();
    final locationCountryController = useTextEditingController();
    final skillsController = useTextEditingController();
    final gearController = useTextEditingController();
    final notesController = useTextEditingController();

    // Form state
    final isFixedPrice = useState(false);
    final locationType = useState(LocationType.remote);
    final currency = useState(Currency.USD);
    final isLoading = useState(false);

    // Initialize date controllers with default values
    useEffect(() {
      final now = DateTime.now();
      final startDate = now.add(const Duration(days: 1));
      final endDate = now.add(const Duration(days: 30));
      
      timelineStartController.text = DateFormat('yyyy-MM-dd').format(startDate);
      timelineEndController.text = DateFormat('yyyy-MM-dd').format(endDate);
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Create Job',
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
            // Basic Information
            _buildSection(
              title: 'Basic Information',
              children: [
                _buildTextField(
                  controller: titleController,
                  label: 'Job Title',
                  hint: 'Enter a clear, descriptive title',
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: descriptionController,
                  label: 'Job Description',
                  hint: 'Describe the project requirements, deliverables, and expectations',
                  maxLines: 5,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Budget Information
            _buildSection(
              title: 'Budget Information',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: budgetMinController,
                        label: 'Minimum Budget',
                        hint: '0',
                        keyboardType: TextInputType.number,
                        prefix: '\$',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: budgetMaxController,
                        label: 'Maximum Budget',
                        hint: '0',
                        keyboardType: TextInputType.number,
                        prefix: '\$',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown<Currency>(
                        value: currency.value,
                        label: 'Currency',
                        items: Currency.values,
                        onChanged: (value) => currency.value = value!,
                        itemBuilder: (currency) => Text(currency.name),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSwitchTile(
                        title: 'Fixed Price',
                        value: isFixedPrice.value,
                        onChanged: (value) => isFixedPrice.value = value,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Timeline
            _buildSection(
              title: 'Timeline',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: timelineStartController,
                        label: 'Start Date',
                        hint: 'YYYY-MM-DD',
                        suffix: 'Start',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: timelineEndController,
                        label: 'End Date',
                        hint: 'YYYY-MM-DD',
                        suffix: 'End',
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Location
            _buildSection(
              title: 'Location',
              children: [
                _buildDropdown<LocationType>(
                  value: locationType.value,
                  label: 'Location Type',
                  items: LocationType.values,
                  onChanged: (value) => locationType.value = value!,
                  itemBuilder: (type) => Text(type.displayName),
                ),
                if (locationType.value != LocationType.remote) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: locationCityController,
                          label: 'City',
                          hint: 'Enter city',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: locationRegionController,
                          label: 'State/Region',
                          hint: 'Enter state or region',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: locationCountryController,
                    label: 'Country',
                    hint: 'Enter country',
                  ),
                ],
              ],
            ),

            const SizedBox(height: 24),

            // Requirements
            _buildSection(
              title: 'Requirements',
              children: [
                _buildTextField(
                  controller: skillsController,
                  label: 'Required Skills',
                  hint: 'e.g., Photography, Video editing, Adobe Creative Suite',
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: gearController,
                  label: 'Required Gear',
                  hint: 'e.g., DSLR camera, lighting equipment, drone',
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: notesController,
                  label: 'Additional Notes',
                  hint: 'Any other requirements or special considerations',
                  maxLines: 3,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Create Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading.value ? null : () => _createJob(
                  context,
                  ref,
                  titleController,
                  descriptionController,
                  budgetMinController,
                  budgetMaxController,
                  timelineStartController,
                  timelineEndController,
                  locationCityController,
                  locationRegionController,
                  locationCountryController,
                  skillsController,
                  gearController,
                  notesController,
                  isFixedPrice.value,
                  locationType.value,
                  currency.value,
                  isLoading,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Create Job',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? prefix,
    String? suffix,
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
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
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
            fillColor: Colors.grey[900],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required String label,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required Widget Function(T) itemBuilder,
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
        DropdownButtonFormField<T>(
          value: value,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          dropdownColor: Colors.grey[900],
          decoration: InputDecoration(
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
            fillColor: Colors.grey[900],
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: itemBuilder(item),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }

  Future<void> _createJob(
    BuildContext context,
    WidgetRef ref,
    TextEditingController titleController,
    TextEditingController descriptionController,
    TextEditingController budgetMinController,
    TextEditingController budgetMaxController,
    TextEditingController timelineStartController,
    TextEditingController timelineEndController,
    TextEditingController locationCityController,
    TextEditingController locationRegionController,
    TextEditingController locationCountryController,
    TextEditingController skillsController,
    TextEditingController gearController,
    TextEditingController notesController,
    bool isFixedPrice,
    LocationType locationType,
    Currency currency,
    ValueNotifier<bool> isLoading,
  ) async {
    // Validate inputs
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a job title')),
      );
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a job description')),
      );
      return;
    }

    final budgetMin = int.tryParse(budgetMinController.text);
    final budgetMax = int.tryParse(budgetMaxController.text);
    
    if (budgetMin == null || budgetMin <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid minimum budget')),
      );
      return;
    }

    if (budgetMax == null || budgetMax <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid maximum budget')),
      );
      return;
    }

    if (budgetMax < budgetMin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum budget must be greater than minimum budget')),
      );
      return;
    }

    final timelineStart = DateTime.tryParse(timelineStartController.text);
    final timelineEnd = DateTime.tryParse(timelineEndController.text);
    
    if (timelineStart == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid start date')),
      );
      return;
    }

    if (timelineEnd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid end date')),
      );
      return;
    }

    if (timelineEnd.isBefore(timelineStart)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after start date')),
      );
      return;
    }

    isLoading.value = true;

    try {
      // Build requirements JSON
      final requirements = <String, dynamic>{};
      if (skillsController.text.trim().isNotEmpty) {
        requirements['skills'] = skillsController.text.split(',').map((s) => s.trim()).toList();
      }
      if (gearController.text.trim().isNotEmpty) {
        requirements['gear'] = gearController.text.split(',').map((s) => s.trim()).toList();
      }
      if (notesController.text.trim().isNotEmpty) {
        requirements['notes'] = notesController.text.trim();
      }

      final jobDraft = JobDraft(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        budgetMin: budgetMin,
        budgetMax: budgetMax,
        currency: currency,
        isFixedPrice: isFixedPrice,
        timelineStart: timelineStart,
        timelineEnd: timelineEnd,
        locationType: locationType,
        locationCity: locationCityController.text.trim(),
        locationRegion: locationRegionController.text.trim(),
        locationCountry: locationCountryController.text.trim(),
        latitude: null, // TODO: Add geocoding
        longitude: null, // TODO: Add geocoding
        requirements: requirements,
      );

      final service = ref.read(jobsServiceProvider);
      await service.createJob(jobDraft);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to job management
      context.pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating job: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
