import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../../../../core/models/models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/glass_container.dart';
import '../../../../core/ui/listing_preview_popup.dart';
import '../../logic/listings_providers.dart';
import '../../components/creator_info.dart';
import '../../../auth/logic/auth_providers.dart';

class ListingCard extends ConsumerWidget {
  const ListingCard({
    required this.listing,
    this.onTap,
    super.key,
  });

  final Listing listing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => showListingPreviewPopup(context, listing),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fiverr-style image section
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: listing.imageUrls?.isNotEmpty == true
                    ? (listing.imageUrls!.first.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: listing.imageUrls!.first,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  _getTypeIcon(listing.type),
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  _getTypeIcon(listing.type),
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          )
                        : Image.file(
                            File(listing.imageUrls!.first),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  _getTypeIcon(listing.type),
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ))
                    : Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            _getTypeIcon(listing.type),
                            size: 40,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
              ),
            ),
            
            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type badge and save button
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getTypeColor(listing.type),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getTypeDisplayName(listing.type),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const Spacer(),
                      Icon(
                        listing.isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: listing.isSaved ? const Color(0xFF8B5CF6) : Colors.grey[600],
                        size: 20,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Title
                  Text(
                    listing.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Creator info
                  Consumer(
                    builder: (context, ref, child) {
                      final userProfile = ref.watch(userProfileProvider);
                      final currentUser = ref.watch(currentUserProvider);
                      
                      return userProfile.when(
                        data: (profile) {
                          // If this is the current user's listing, show their profile
                          if (listing.creatorId == currentUser?.id) {
                            final displayName = profile?.fullName ?? (currentUser?.userMetadata?['name'] as String?) ?? 'You';
                            final displayUsername = profile?.username ?? (currentUser?.email?.split('@').first ?? 'you');
                            final avatarUrl = profile?.avatarUrl;
                            final isVerified = profile?.isVerified ?? false;
                            return CreatorInfo(
                              creatorId: listing.creatorId,
                              creatorName: displayName,
                              creatorUsername: displayUsername,
                              creatorAvatarUrl: avatarUrl,
                              isVerified: isVerified,
                              onTap: () {
                                // Navigate to own profile
                                context.push('/profile');
                              },
                            );
                          }
                          
                          // Otherwise, use demo data for other creators
                          return CreatorInfo(
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
                          );
                        },
                        loading: () => CreatorInfo(
                          creatorId: listing.creatorId,
                          creatorName: DemoCreators.getCreator(listing.creatorId)?.fullName,
                          creatorUsername: DemoCreators.getCreator(listing.creatorId)?.username,
                          creatorAvatarUrl: DemoCreators.getCreator(listing.creatorId)?.avatarUrl,
                          isVerified: DemoCreators.isCreatorVerified(listing.creatorId),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Viewing ${DemoCreators.getCreatorName(listing.creatorId)} profile'),
                                backgroundColor: const Color(0xFF8B5CF6),
                              ),
                            );
                          },
                        ),
                        error: (_, __) => CreatorInfo(
                          creatorId: listing.creatorId,
                          creatorName: DemoCreators.getCreator(listing.creatorId)?.fullName,
                          creatorUsername: DemoCreators.getCreator(listing.creatorId)?.username,
                          creatorAvatarUrl: DemoCreators.getCreator(listing.creatorId)?.avatarUrl,
                          isVerified: DemoCreators.isCreatorVerified(listing.creatorId),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Viewing ${DemoCreators.getCreatorName(listing.creatorId)} profile'),
                                backgroundColor: const Color(0xFF8B5CF6),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Price and stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${listing.budget?.toStringAsFixed(0) ?? 'TBD'}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B5CF6),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${listing.viewCount}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[300],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(ListingType type) {
    switch (type) {
      case ListingType.photography:
        return Icons.camera_alt_outlined;
      case ListingType.videography:
        return Icons.videocam_outlined;
      case ListingType.modeling:
        return Icons.person_outline;
      case ListingType.casting:
        return Icons.group_outlined;
    }
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