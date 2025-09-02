import '../models/models.dart';
import '../constants.dart';

class DemoCreators {
  static final Map<String, Profile> creators = {
    'demo-user-1': Profile(
      id: 'demo-user-1',
      userId: 'demo-user-1',
      fullName: 'Sarah Johnson',
      username: 'sarah_photo',
      bio: 'Professional portrait photographer with 8+ years of experience',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
      role: UserRole.photographer,
      location: 'New York, NY',
      hourlyRate: 75.0,
      yearsExperience: 8,
      isVerified: true,
      rating: 4.9,
      totalJobs: 156,
      createdAt: DateTime.now().subtract(const Duration(days: 1000)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    
    'demo-user-2': Profile(
      id: 'demo-user-2',
      userId: 'demo-user-2',
      fullName: 'Michael Chen',
      username: 'mike_weddings',
      bio: 'Award-winning wedding photographer specializing in elegant ceremonies',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      role: UserRole.photographer,
      location: 'Los Angeles, CA',
      hourlyRate: 120.0,
      yearsExperience: 12,
      isVerified: true,
      rating: 5.0,
      totalJobs: 89,
      createdAt: DateTime.now().subtract(const Duration(days: 1200)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    
    'demo-user-3': Profile(
      id: 'demo-user-3',
      userId: 'demo-user-3',
      fullName: 'Emily Rodriguez',
      username: 'emily_video',
      bio: 'Corporate video producer helping businesses tell their stories',
      avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      role: UserRole.videographer,
      location: 'Chicago, IL',
      hourlyRate: 95.0,
      yearsExperience: 6,
      isVerified: true,
      rating: 4.8,
      totalJobs: 203,
      createdAt: DateTime.now().subtract(const Duration(days: 800)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    
    'demo-user-4': Profile(
      id: 'demo-user-4',
      userId: 'demo-user-4',
      fullName: 'Alex Thompson',
      username: 'alex_music',
      bio: 'Creative music video director with a passion for storytelling',
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      role: UserRole.videographer,
      location: 'Austin, TX',
      hourlyRate: 110.0,
      yearsExperience: 9,
      isVerified: true,
      rating: 4.9,
      totalJobs: 67,
      createdAt: DateTime.now().subtract(const Duration(days: 900)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    
    'demo-user-5': Profile(
      id: 'demo-user-5',
      userId: 'demo-user-5',
      fullName: 'Jessica Park',
      username: 'jess_model',
      bio: 'Fashion model and influencer with experience in commercial shoots',
      avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
      role: UserRole.model,
      location: 'Miami, FL',
      hourlyRate: 85.0,
      yearsExperience: 5,
      isVerified: true,
      rating: 4.7,
      totalJobs: 134,
      createdAt: DateTime.now().subtract(const Duration(days: 700)),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    
    'demo-user-6': Profile(
      id: 'demo-user-6',
      userId: 'demo-user-6',
      fullName: 'David Wilson',
      username: 'dave_agency',
      bio: 'Talent agency owner representing top creative professionals',
      avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      role: UserRole.agency,
      location: 'San Francisco, CA',
      hourlyRate: 150.0,
      yearsExperience: 15,
      isVerified: true,
      rating: 4.9,
      totalJobs: 445,
      createdAt: DateTime.now().subtract(const Duration(days: 1500)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  };

  static Profile? getCreator(String creatorId) {
    return creators[creatorId];
  }

  static String getCreatorName(String creatorId) {
    final creator = creators[creatorId];
    return creator?.fullName ?? creator?.username ?? 'Unknown Creator';
  }

  static String? getCreatorAvatar(String creatorId) {
    return creators[creatorId]?.avatarUrl;
  }

  static bool isCreatorVerified(String creatorId) {
    return creators[creatorId]?.isVerified ?? false;
  }
}
