import '../../../core/models/models.dart';

class DemoListings {
  static List<Listing> get demoListings => [
    // Photography Listings
    Listing(
      id: 'demo-photo-1',
      creatorId: 'demo-user-1',
      title: 'Professional Portrait Photography Session',
      description: 'Capture your best moments with our professional portrait photography service. Perfect for LinkedIn profiles, dating apps, or personal branding. We specialize in natural lighting and authentic expressions.',
      type: ListingType.photography,
      locationText: 'Downtown Studio, New York',
      budget: 150.0,
      eventDurationHours: 2,
      imageUrls: [
        'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=800',
        'https://images.unsplash.com/photo-1554151228-14d9def656e4?w=800',
      ],
      tags: ['portrait', 'professional', 'studio', 'lighting'],
      requiredSkills: ['Professional attire recommended. Please arrive 15 minutes early.'],
      status: ListingStatus.active,
      contactMethod: ContactMethod.in_app,
      photographyCategories: [PhotographyCategory.portrait, PhotographyCategory.commercial],
      isNegotiable: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    
    Listing(
      id: 'demo-photo-2',
      creatorId: 'demo-user-2',
      title: 'Wedding Photography & Videography Package',
      description: 'Complete wedding coverage including ceremony, reception, and engagement session. Professional editing and high-resolution delivery. Perfect for your special day.',
      type: ListingType.photography,
      locationText: 'Various Venues, Los Angeles',
      budget: 2500.0,
      eventDurationHours: 8,
      imageUrls: [
        'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800',
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=800',
      ],
      tags: ['wedding', 'ceremony', 'reception', 'engagement'],
      requiredSkills: ['Venue access required. Timeline planning session included.'],
      status: ListingStatus.active,
      contactMethod: ContactMethod.in_app,
      photographyCategories: [PhotographyCategory.wedding, PhotographyCategory.event],
      isNegotiable: false,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),

    // Videography Listings
    Listing(
      id: 'demo-video-1',
      creatorId: 'demo-user-3',
      title: 'Corporate Video Production Services',
      description: 'Professional corporate videos for marketing, training, and internal communications. High-quality production with professional editing and motion graphics.',
      type: ListingType.videography,
      locationText: 'Business District, Chicago',
      budget: 800.0,
      eventDurationHours: 4,
      imageUrls: [
        'https://images.unsplash.com/photo-1556761175-b413da4baf72?w=800',
        'https://images.unsplash.com/photo-1556761175-4a5c5c0b0b0b?w=800',
      ],
      tags: ['corporate', 'marketing', 'training', 'professional'],
      requiredSkills: ['Business casual attire. Script or outline preferred.'],
      status: ListingStatus.active,
      contactMethod: ContactMethod.in_app,
      videographyCategories: [VideographyCategory.corporate, VideographyCategory.commercial],
      isNegotiable: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),

    Listing(
      id: 'demo-video-2',
      creatorId: 'demo-user-4',
      title: 'Music Video Production',
      description: 'Creative music video production for artists and bands. Concept development, filming, and post-production included. Perfect for indie artists and established musicians.',
      type: ListingType.videography,
      locationText: 'Creative District, Austin',
      budget: 1200.0,
      eventDurationHours: 6,
      imageUrls: [
        'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800',
        'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=800',
      ],
      tags: ['music', 'creative', 'artistic', 'production'],
      requiredSkills: ['Music track required. Concept discussion included.'],
      status: ListingStatus.active,
      contactMethod: ContactMethod.in_app,
      videographyCategories: [VideographyCategory.music_video, VideographyCategory.commercial],
      isNegotiable: false,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),

    // Modeling Listings
    Listing(
      id: 'demo-model-1',
      creatorId: 'demo-user-5',
      title: 'Fashion Model for Brand Campaign',
      description: 'Seeking experienced fashion models for upcoming brand campaign. Professional photoshoot with established photographer. Great portfolio opportunity.',
      type: ListingType.modeling,
      locationText: 'Fashion District, Miami',
      budget: 300.0,
      eventDurationHours: 3,
      imageUrls: [
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
      ],
      tags: ['fashion', 'brand', 'campaign', 'professional'],
      requiredSkills: ['Fashion modeling experience required. Portfolio review.'],
      status: ListingStatus.active,
      contactMethod: ContactMethod.in_app,
      modelingCategories: [ModelingCategory.fashion, ModelingCategory.commercial],
      isNegotiable: false,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),

    Listing(
      id: 'demo-model-2',
      creatorId: 'demo-user-6',
      title: 'Fitness Model for Athletic Wear',
      description: 'Athletic wear brand seeking fitness models for product photography and marketing materials. Active lifestyle and fitness background preferred.',
      type: ListingType.modeling,
      locationText: 'Sports Complex, Denver',
      budget: 250.0,
      eventDurationHours: 2,
      imageUrls: [
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
      ],
      tags: ['fitness', 'athletic', 'sports', 'lifestyle'],
      requiredSkills: ['Fitness background preferred. Athletic wear provided.'],
      status: ListingStatus.active,
      contactMethod: ContactMethod.in_app,
      modelingCategories: [ModelingCategory.fitness, ModelingCategory.lifestyle],
      isNegotiable: false,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),

    // Casting Listings
    Listing(
      id: 'demo-casting-1',
      creatorId: 'demo-user-7',
      title: 'Background Actors for TV Series',
      description: 'Casting background actors for upcoming TV series. Various roles available. Great opportunity for aspiring actors to gain experience.',
      type: ListingType.casting,
      locationText: 'Studio Lot, Burbank',
      budget: 150.0,
      eventDurationHours: 8,
      imageUrls: [
        'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800',
        'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800',
      ],
      tags: ['background', 'tv', 'series', 'acting'],
      requiredSkills: ['No experience required. Flexible schedule needed.'],
      status: ListingStatus.active,
      contactMethod: ContactMethod.in_app,
      isNegotiable: false,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),

    Listing(
      id: 'demo-casting-2',
      creatorId: 'demo-user-8',
      title: 'Voice Over Artist for Commercial',
      description: 'Seeking professional voice over artist for national commercial campaign. Clear, engaging voice required. Professional recording studio available.',
      type: ListingType.casting,
      locationText: 'Recording Studio, Nashville',
      budget: 500.0,
      eventDurationHours: 2,
      imageUrls: [
        'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=800',
        'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=800',
      ],
      tags: ['voice', 'commercial', 'recording', 'professional'],
      requiredSkills: ['Voice over experience required. Demo reel preferred.'],
      status: ListingStatus.active,
      contactMethod: ContactMethod.in_app,
      isNegotiable: false,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      updatedAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  static List<Listing> getLimitedListings(int limit) {
    return demoListings.take(limit).toList();
  }

  static List<Listing> getListingsByType(ListingType type) {
    return demoListings.where((listing) => listing.type == type).toList();
  }
}
