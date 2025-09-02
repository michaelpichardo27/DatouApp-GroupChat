import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';
import 'signup_popup.dart';
import '../../features/listings/components/creator_info.dart';
import '../../features/auth/logic/auth_providers.dart';

class ListingPreviewPopup extends StatelessWidget {
  const ListingPreviewPopup({
    required this.listing,
    super.key,
  });

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1F2937),
              Color(0xFF111827),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[800]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      listing.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Images carousel
                    if (listing.imageUrls?.isNotEmpty == true) ...[
                      _Carousel(imageUrls: listing.imageUrls!),
                      const SizedBox(height: 20),
                    ],
                    
                    // Type and budget
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(listing.type).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getTypeColor(listing.type).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _getTypeDisplayName(listing.type),
                            style: TextStyle(
                              color: _getTypeColor(listing.type),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            '\$${listing.budget?.toStringAsFixed(0) ?? 'TBD'}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Creator info
                    Row(
                      children: [
                        const Text(
                          'Posted by',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        CreatorInfo(
                          creatorId: listing.creatorId,
                          creatorName: DemoCreators.getCreator(listing.creatorId)?.fullName,
                          creatorUsername: DemoCreators.getCreator(listing.creatorId)?.username,
                          creatorAvatarUrl: DemoCreators.getCreator(listing.creatorId)?.avatarUrl,
                          isVerified: DemoCreators.isCreatorVerified(listing.creatorId),
                          onTap: () {
                            // TODO: Navigate to creator profile
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Viewing ${DemoCreators.getCreatorName(listing.creatorId)} profile'),
                                backgroundColor: const Color(0xFF8B5CF6),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      listing.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Details grid
                    _buildDetailRow('Location', listing.locationText),
                    if (listing.eventDurationHours != null)
                      _buildDetailRow('Duration', '${listing.eventDurationHours} hours'),
                    if (listing.eventDate != null)
                      _buildDetailRow('Event Date', DateFormat('MMM d, y').format(listing.eventDate!)),
                    if (listing.applicationDeadline != null)
                      _buildDetailRow('Deadline', DateFormat('MMM d, y').format(listing.applicationDeadline!)),
                    
                    const SizedBox(height: 20),
                    
                    // Requirements
                    if (listing.requiredSkills?.isNotEmpty == true) ...[
                      const Text(
                        'Requirements',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...listing.requiredSkills!.map((skill) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                skill,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(height: 20),
                    ],
                    
                    // Tags
                    if (listing.tags?.isNotEmpty == true) ...[
                      const Text(
                        'Tags',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: listing.tags!.map((tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF8B5CF6).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: Color(0xFF8B5CF6),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                    
                    // Stats
                    Row(
                      children: [
                        _buildStat('Views', listing.viewCount, Icons.visibility),
                        const SizedBox(width: 20),
                        _buildStat('Applications', listing.applicationCount, Icons.person_add),
                        const SizedBox(width: 20),
                        _buildStat('Saves', listing.saveCount, Icons.bookmark),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Action buttons
                    Consumer(
                      builder: (context, ref, child) {
                        final user = ref.watch(currentUserProvider);
                        final isGuest = ref.watch(guestModeProvider);
                        
                        // Only show Apply button for unauthenticated users
                        if (user == null && !isGuest) {
                          return Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    showSignUpPopup(context);
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
                                    'Apply Now',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                onPressed: () {
                                  // TODO: Implement save functionality
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                  foregroundColor: Colors.white,
                                ),
                                icon: Icon(
                                  listing.isSaved ? Icons.bookmark : Icons.bookmark_border,
                                  size: 24,
                                ),
                              ),
                            ],
                          );
                        }
                        
                        // For authenticated users, show different actions
                        return Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // TODO: Navigate to application form or show application modal
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Application feature coming soon!'),
                                      backgroundColor: Color(0xFF8B5CF6),
                                    ),
                                  );
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
                                  'Contact Creator',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              onPressed: () {
                                // TODO: Implement save functionality
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                foregroundColor: Colors.white,
                              ),
                              icon: Icon(
                                listing.isSaved ? Icons.bookmark : Icons.bookmark_border,
                                size: 24,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, int count, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.grey[400],
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Color _getTypeColor(ListingType type) {
    switch (type) {
      case ListingType.photography:
        return Colors.blue;
      case ListingType.videography:
        return Colors.purple;
      case ListingType.modeling:
        return Colors.pink;
      case ListingType.casting:
        return Colors.orange;
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
}

class _Carousel extends StatefulWidget {
  const _Carousel({required this.imageUrls});
  final List<String> imageUrls;

  @override
  State<_Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<_Carousel> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PageView.builder(
              onPageChanged: (i) => setState(() => index = i),
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, i) {
                final url = widget.imageUrls[i];
                return url.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(url),
                        fit: BoxFit.cover,
                      );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.imageUrls.length, (i) {
            final active = i == index;
            return Container(
              width: active ? 10 : 6,
              height: active ? 10 : 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: active ? const Color(0xFF8B5CF6) : Colors.grey[700],
                shape: BoxShape.circle,
              ),
            );
          }),
        )
      ],
    );
  }
}

// Helper function to show the popup
void showListingPreviewPopup(BuildContext context, Listing listing) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => ListingPreviewPopup(listing: listing),
  );
}
