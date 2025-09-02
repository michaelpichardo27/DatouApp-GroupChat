import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/models/models.dart';
import '../../../core/data/demo_listings.dart';
import '../data/listings_repository.dart';
import '../../auth/logic/auth_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final myListingsProvider = StateNotifierProvider<MyListingsNotifier, AsyncValue<List<Listing>>>((ref) {
  return MyListingsNotifier();
});

class MyListingsNotifier extends StateNotifier<AsyncValue<List<Listing>>> {
  MyListingsNotifier() : super(const AsyncValue.loading()) {
    _loadMyListings();
  }

  Future<void> _loadMyListings() async {
    try {
      // Only set loading state if we don't have any data yet
      if (state is! AsyncData<List<Listing>>) {
        state = const AsyncValue.loading();
      }
      
      // Get current user
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        // If no user is signed in, show empty list
        state = const AsyncValue.data([]);
        return;
      }

      // Fetch user's listings from the database
      final repository = ListingsRepository();
      final response = await Supabase.instance.client
          .from('listings')
          .select('*')
          .eq('creator_id', currentUser.id)
          .order('created_at', ascending: false);

      final listings = (response as List)
          .map<Listing>((json) => Listing.fromJson(json))
          .toList();

      state = AsyncValue.data(listings);
      
      print('Loaded ${listings.length} listings for user ${currentUser.id}');
    } catch (error, stackTrace) {
      print('Error loading my listings: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }



  Future<void> refresh() async {
    // Always refresh from database
    await _loadMyListings();
  }

  Future<void> updateListingStatus(String listingId, ListingStatus newStatus) async {
    final currentState = state;
    if (currentState is! AsyncData<List<Listing>>) return;

    try {
      // Update in database
      final repository = ListingsRepository();
      await repository.updateListing(listingId, currentState.value.firstWhere((l) => l.id == listingId).copyWith(status: newStatus));

      // Update local state
      final updatedListings = currentState.value.map((listing) {
        if (listing.id == listingId) {
          return listing.copyWith(status: newStatus);
        }
        return listing;
      }).toList();

      state = AsyncValue.data(updatedListings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteListing(String listingId) async {
    final currentState = state;
    if (currentState is! AsyncData<List<Listing>>) return;

    try {
      // Delete from database
      final repository = ListingsRepository();
      await repository.deleteListing(listingId);

      // Update local state
      final updatedListings = currentState.value
          .where((listing) => listing.id != listingId)
          .toList();

      state = AsyncValue.data(updatedListings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateListing(String listingId, Listing updatedListing) async {
    final currentState = state;
    if (currentState is! AsyncData<List<Listing>>) return;

    try {
      final updatedListings = currentState.value.map((listing) {
        if (listing.id == listingId) {
          return updatedListing;
        }
        return listing;
      }).toList();

      state = AsyncValue.data(updatedListings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addListing(Listing newListing) async {
    try {
      final currentState = state;
      List<Listing> currentListings = [];
      
      if (currentState is AsyncData<List<Listing>>) {
        currentListings = currentState.value;
      }
      
      final updatedListings = [newListing, ...currentListings];
      state = AsyncValue.data(updatedListings);
    } catch (error, stackTrace) {
      // If there's an error, just set the new listing as the only item
      state = AsyncValue.data([newListing]);
    }
  }

  // Force update the state to ensure the listing is added
  void forceAddListing(Listing newListing) {
    final currentState = state;
    List<Listing> currentListings = [];
    
    if (currentState is AsyncData<List<Listing>>) {
      currentListings = currentState.value;
    }
    
    // Add the new listing to the beginning of the list
    final updatedListings = [newListing, ...currentListings];
    
    // Force update the state immediately
    state = AsyncValue.data(updatedListings);
    
    print('Added listing: ${newListing.title} - Total listings: ${updatedListings.length}');
  }
}
