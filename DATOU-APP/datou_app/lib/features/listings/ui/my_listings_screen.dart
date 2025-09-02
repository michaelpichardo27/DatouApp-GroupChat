import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/glass_container.dart';
import '../logic/listings_providers.dart';
import '../logic/my_listings_provider.dart';
import 'widgets/listing_card.dart';

class MyListingsScreen extends HookConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Content
            Expanded(
              child: _buildContent(context, ref),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              'My Listings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final myListingsState = ref.watch(myListingsProvider);
        
        return myListingsState.when(
          data: (listings) {
            if (listings.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildListingsList(context, ref, listings);
          },
          loading: () => const _LoadingState(),
          error: (error, stackTrace) => _buildErrorState(context, error.toString()),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list_alt_outlined,
            size: 80,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 24),
          Text(
            'No Listings Yet',
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Create your first listing to get started',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),

        ],
      ),
    );
  }

  Widget _buildListingsList(BuildContext context, WidgetRef ref, List<Listing> listings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: listings.length,
      itemBuilder: (context, index) {
        final listing = listings[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildListingCard(context, ref, listing),
        );
      },
    );
  }

  Widget _buildListingCard(BuildContext context, WidgetRef ref, Listing listing) {
    return GlassContainer(
      child: Column(
        children: [
          // Listing content
          ListingCard(
            listing: listing,
            onTap: () {
              // Show listing preview
              showDialog(
                context: context,
                builder: (context) => _buildListingPreviewDialog(context, listing),
              );
            },
          ),
          
          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editListing(context, listing),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF8B5CF6),
                      side: const BorderSide(color: Color(0xFF8B5CF6)),
                    ),
                    icon: const Icon(Icons.edit, size: 20),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _toggleListingStatus(context, ref, listing),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: listing.status == ListingStatus.active 
                          ? Colors.orange 
                          : Colors.green,
                      side: BorderSide(
                        color: listing.status == ListingStatus.active 
                            ? Colors.orange 
                            : Colors.green,
                      ),
                      minimumSize: const Size(0, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    icon: Icon(
                      listing.status == ListingStatus.active 
                          ? Icons.pause 
                          : Icons.play_arrow,
                      size: 20,
                    ),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        listing.status == ListingStatus.active ? 'Pause' : 'Activate',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _deleteListing(context, ref, listing),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    icon: const Icon(Icons.delete, size: 20),
                    label: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListingPreviewDialog(BuildContext context, Listing listing) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF333333)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      listing.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(listing.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        listing.status.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    Text(
                      listing.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Details
                    _buildDetailRow('Type', listing.type.name),
                    _buildDetailRow('Budget', '\$${listing.budget?.toStringAsFixed(2) ?? 'Negotiable'}'),
                    _buildDetailRow('Location', listing.locationText),
                    if (listing.eventDurationHours != null)
                      _buildDetailRow('Duration', '${listing.eventDurationHours} hours'),
                    _buildDetailRow('Created', _formatDate(listing.createdAt)),
                    _buildDetailRow('Views', listing.viewCount.toString()),
                    _buildDetailRow('Applications', listing.applicationCount.toString()),
                    _buildDetailRow('Saves', listing.saveCount.toString()),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  Color _getStatusColor(ListingStatus status) {
    switch (status) {
      case ListingStatus.active:
        return Colors.green;
      case ListingStatus.paused:
        return Colors.orange;
      case ListingStatus.draft:
        return Colors.grey;
      case ListingStatus.completed:
        return Colors.blue;
      case ListingStatus.cancelled:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _editListing(BuildContext context, Listing listing) {
    // Navigate to edit listing screen with listing data
    context.push('/edit-listing/${listing.id}', extra: listing);
  }

  void _toggleListingStatus(BuildContext context, WidgetRef ref, Listing listing) {
    final newStatus = listing.status == ListingStatus.active 
        ? ListingStatus.paused 
        : ListingStatus.active;
    
    ref.read(myListingsProvider.notifier).updateListingStatus(
      listing.id, 
      newStatus,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Listing ${newStatus == ListingStatus.active ? 'activated' : 'paused'}',
        ),
        backgroundColor: const Color(0xFF8B5CF6),
      ),
    );
  }

  void _deleteListing(BuildContext context, WidgetRef ref, Listing listing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Delete Listing',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${listing.title}"? This action cannot be undone.',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(myListingsProvider.notifier).deleteListing(listing.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Listing deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF8B5CF6),
      ),
    );
  }
}

Widget _buildErrorState(BuildContext context, String error) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 80,
          color: Colors.red[400],
        ),
        const SizedBox(height: 24),
        Text(
          'Error Loading Listings',
          style: TextStyle(
            color: Colors.red[400],
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          error,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
