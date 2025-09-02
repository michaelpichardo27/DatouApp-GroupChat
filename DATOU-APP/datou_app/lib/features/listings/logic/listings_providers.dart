import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/models/models.dart';
import '../../../core/data/demo_listings.dart';
import '../../../core/providers/auth_provider.dart';
import '../data/listings_repository.dart';
import 'my_listings_provider.dart';

final listingsRepositoryProvider = Provider<ListingsRepository>((ref) {
  return ListingsRepository();
});

final listingsFiltersProvider = StateProvider<ListingFilters>((ref) {
  return const ListingFilters();
});

// Provider to check if user is in guest mode
// Guest mode is now determined by auth state
final isGuestModeProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isGuest;
});

final listingsProvider = StateNotifierProvider<ListingsNotifier, AsyncValue<ListingSearchResult>>((ref) {
  return ListingsNotifier(ref);
});

final savedListingsProvider = StateNotifierProvider<SavedListingsNotifier, AsyncValue<List<Listing>>>((ref) {
  return SavedListingsNotifier(ref);
});

final categoryOptionsProvider = FutureProvider.family<List<String>, ListingType>((ref, type) {
  final repository = ref.read(listingsRepositoryProvider);
  return repository.getCategoryOptions(type);
});

final recommendedListingsProvider = FutureProvider<List<Listing>>((ref) {
  final repository = ref.read(listingsRepositoryProvider);
  return repository.getRecommendedListings();
});

final trendingSearchesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repository = ref.read(listingsRepositoryProvider);
  return repository.getTrendingSearches();
});

class ListingsNotifier extends StateNotifier<AsyncValue<ListingSearchResult>> {
  ListingsNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initializeLocation();
    loadListings();
  }

  final Ref ref;
  Position? _currentLocation;

  Future<void> _initializeLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestPermission = await Geolocator.requestPermission();
        if (requestPermission == LocationPermission.denied) {
          return; // No location access
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return; // Location permissions are permanently denied
      }

      _currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      // Update filters with user location
      final currentFilters = ref.read(listingsFiltersProvider);
      ref.read(listingsFiltersProvider.notifier).state = currentFilters.copyWith(
        userLat: _currentLocation?.latitude,
        userLng: _currentLocation?.longitude,
      );
    } catch (e) {
      // Location access failed, continue without location
      print('Failed to get location: $e');
    }
  }

  Future<void> loadListings({bool refresh = false}) async {
    if (refresh) {
      state = const AsyncValue.loading();
    }

    try {
      // Use demo data for all users (both guests and authenticated)
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate loading
      
      final demoListings = DemoListings.demoListings;
      final currentFilters = ref.read(listingsFiltersProvider);
      
      // Apply filters to demo data
      List<Listing> filteredListings = demoListings;
      
      // Filter by type if specified
      if (currentFilters.types != null && currentFilters.types!.isNotEmpty) {
        filteredListings = filteredListings.where((listing) => 
          currentFilters.types!.contains(listing.type)
        ).toList();
      }
      
      // Filter by categories if specified
      if (currentFilters.categories?.isNotEmpty == true) {
        filteredListings = filteredListings.where((listing) {
          final listingType = listing.type.name;
          if (currentFilters.categories?.containsKey(listingType) == true) {
            final requiredCategories = currentFilters.categories![listingType]!;
            if (requiredCategories.isNotEmpty) {
              // Check if listing has any of the required categories
              switch (listing.type) {
                case ListingType.photography:
                  return listing.photographyCategories?.any((cat) => 
                    requiredCategories.contains(cat.name)
                  ) ?? false;
                case ListingType.videography:
                  return listing.videographyCategories?.any((cat) => 
                    requiredCategories.contains(cat.name)
                  ) ?? false;
                case ListingType.modeling:
                  return listing.modelingCategories?.any((cat) => 
                    requiredCategories.contains(cat.name)
                  ) ?? false;
                case ListingType.casting:
                  // Casting doesn't have categories in the current model
                  return true;
              }
            }
          }
          return true;
        }).toList();
      }
      
      // Apply sorting
      switch (currentFilters.sortBy) {
        case SortOption.newest:
          filteredListings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case SortOption.oldest:
          filteredListings.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
        case SortOption.budget_low:
          filteredListings.sort((a, b) => (a.budget ?? 0).compareTo(b.budget ?? 0));
          break;
        case SortOption.budget_high:
          filteredListings.sort((a, b) => (b.budget ?? 0).compareTo(a.budget ?? 0));
          break;
        case SortOption.deadline:
          // For demo, just keep original order
          break;
        case SortOption.recommended:
          // For demo, just keep original order
          break;
      }
      
      final result = ListingSearchResult(
        listings: filteredListings,
        totalCount: filteredListings.length,
        hasMore: false,
        currentPage: 1,
      );
      
      state = AsyncValue.data(result);
      
      // TODO: Later implement real Supabase listings for authenticated users
      // if (authState.isAuthenticated) {
      //   final repository = ref.read(listingsRepositoryProvider);
      //   final filters = ref.read(listingsFiltersProvider);
      //   final result = await repository.searchListings(
      //     refresh ? filters.copyWith(pageOffset: 0) : filters,
      //   );
      //   state = AsyncValue.data(result);
      // }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMoreListings() async {
    final currentState = state;
    if (currentState is! AsyncData<ListingSearchResult>) return;

    final currentResult = currentState.value;
    if (!currentResult.hasMore) return;

    try {
      final repository = ref.read(listingsRepositoryProvider);
      final filters = ref.read(listingsFiltersProvider);
      
      final newFilters = filters.copyWith(
        pageOffset: filters.pageOffset + filters.pageLimit,
      );

      final newResult = await repository.searchListings(newFilters);
      
      // Merge results
      final mergedListings = [...currentResult.listings, ...newResult.listings];
      final mergedResult = ListingSearchResult(
        listings: mergedListings,
        totalCount: newResult.totalCount,
        hasMore: newResult.hasMore,
        currentPage: newResult.currentPage,
      );

      state = AsyncValue.data(mergedResult);
      
      // Update filters with new offset
      ref.read(listingsFiltersProvider.notifier).state = newFilters;
    } catch (error, stackTrace) {
      // Keep current state on error, just log
      print('Failed to load more listings: $error');
    }
  }

  Future<void> refresh() async {
    // Reset filters offset
    final currentFilters = ref.read(listingsFiltersProvider);
    ref.read(listingsFiltersProvider.notifier).state = currentFilters.copyWith(pageOffset: 0);
    
    await loadListings(refresh: true);
  }

  Future<void> updateFilters(ListingFilters newFilters) async {
    ref.read(listingsFiltersProvider.notifier).state = newFilters.copyWith(pageOffset: 0);
    await loadListings(refresh: true);
  }

  Future<bool> toggleSave(String listingId) async {
    try {
      final repository = ref.read(listingsRepositoryProvider);
      final isSaved = await repository.toggleSave(listingId);
      
      // Update the listing in current state
      final currentState = state;
      if (currentState is AsyncData<ListingSearchResult>) {
        final updatedListings = currentState.value.listings.map((listing) {
          if (listing.id == listingId) {
            return listing.copyWith(isSaved: isSaved);
          }
          return listing;
        }).toList();

        final updatedResult = currentState.value.copyWith(listings: updatedListings);
        state = AsyncValue.data(updatedResult);
      }
      
      return isSaved;
    } catch (e) {
      print('Failed to toggle save: $e');
      return false;
    }
  }

  bool get hasMoreData {
    final currentState = state;
    return currentState is AsyncData<ListingSearchResult> ? currentState.value.hasMore : false;
  }

  Future<void> addListing(Listing newListing) async {
    try {
      final currentState = state;
      if (currentState is AsyncData<ListingSearchResult>) {
        final currentListings = currentState.value.listings;
        final updatedListings = [newListing, ...currentListings];
        
        final updatedResult = currentState.value.copyWith(
          listings: updatedListings,
          totalCount: currentState.value.totalCount + 1,
        );
        
        state = AsyncValue.data(updatedResult);
      }
    } catch (error, stackTrace) {
      print('Failed to add listing: $error');
    }
  }
}

class SavedListingsNotifier extends StateNotifier<AsyncValue<List<Listing>>> {
  SavedListingsNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadSavedListings();
  }

  final Ref ref;

  Future<void> loadSavedListings({bool refresh = false}) async {
    if (refresh) {
      state = const AsyncValue.loading();
    }

    try {
      final repository = ref.read(listingsRepositoryProvider);
      final savedListings = await repository.getSavedListings();
      state = AsyncValue.data(savedListings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadSavedListings(refresh: true);
  }
}