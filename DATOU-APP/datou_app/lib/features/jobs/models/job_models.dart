import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/models/profile_model.dart';

part 'job_models.freezed.dart';
part 'job_models.g.dart';

// MARK: - Enums
enum Currency {
  USD,
  EUR,
  GBP,
  CAD,
  AUD,
}

enum JobStatus {
  open,
  hiring,
  closed,
}

enum LocationType {
  remote,
  onsite,
  hybrid,
}

enum ApplicationStatus {
  submitted,
  shortlisted,
  declined,
  hired,
}

// MARK: - Core Models
@freezed
class Job with _$Job {
  const factory Job({
    required String id,
    required String clientId,
    required String title,
    required String description,
    required int budgetMin,
    required int budgetMax,
    required Currency currency,
    required bool isFixedPrice,
    required DateTime timelineStart,
    required DateTime timelineEnd,
    required LocationType locationType,
    String? locationCity,
    String? locationRegion,
    String? locationCountry,
    double? latitude,
    double? longitude,
    required Map<String, dynamic> requirements,
    required JobStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    Profile? client,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

  const Job._();

  // Validation helpers
  bool get isValidBudget => budgetMin <= budgetMax && budgetMin > 0;
  bool get isValidTimeline => timelineStart.isBefore(timelineEnd);
  bool get hasLocation => locationCity != null || latitude != null;
  bool get isOpen => status == JobStatus.open;
  bool get isHiring => status == JobStatus.hiring;
  bool get isClosed => status == JobStatus.closed;
  
  String get budgetDisplay {
    if (budgetMin == budgetMax) {
      return '\$${budgetMin.toStringAsFixed(0)}';
    }
    return '\$${budgetMin.toStringAsFixed(0)} - \$${budgetMax.toStringAsFixed(0)}';
  }
  
  String get locationDisplay {
    switch (locationType) {
      case LocationType.remote:
        return 'Remote';
      case LocationType.onsite:
        if (locationCity != null && locationCountry != null) {
          return '$locationCity, $locationCountry';
        } else if (locationCity != null) {
          return locationCity!;
        } else if (locationCountry != null) {
          return locationCountry!;
        }
        return 'On-site';
      case LocationType.hybrid:
        if (locationCity != null && locationCountry != null) {
          return 'Hybrid - $locationCity, $locationCountry';
        } else if (locationCity != null) {
          return 'Hybrid - $locationCity';
        } else if (locationCountry != null) {
          return 'Hybrid - $locationCountry';
        }
        return 'Hybrid';
    }
  }
}

@freezed
class Application with _$Application {
  const factory Application({
    required String id,
    required String jobId,
    required String creatorId,
    required String coverLetter,
    required int proposedAmount,
    String? proposedTerms,
    required ApplicationStatus status,
    required DateTime createdAt,
    Profile? creator,
  }) = _Application;

  factory Application.fromJson(Map<String, dynamic> json) => _$ApplicationFromJson(json);

  const Application._();

  bool get isSubmitted => status == ApplicationStatus.submitted;
  bool get isShortlisted => status == ApplicationStatus.shortlisted;
  bool get isDeclined => status == ApplicationStatus.declined;
  bool get isHired => status == ApplicationStatus.hired;
}

@freezed
class Hire with _$Hire {
  const factory Hire({
    required String id,
    required String jobId,
    required String applicationId,
    required int agreedAmount,
    required String agreedTerms,
    required DateTime hiredAt,
    Application? application,
  }) = _Hire;

  factory Hire.fromJson(Map<String, dynamic> json) => _$HireFromJson(json);
}

// MARK: - Input Models
@freezed
class JobDraft with _$JobDraft {
  const factory JobDraft({
    required String title,
    required String description,
    required int budgetMin,
    required int budgetMax,
    required Currency currency,
    required bool isFixedPrice,
    required DateTime timelineStart,
    required DateTime timelineEnd,
    required LocationType locationType,
    String? locationCity,
    String? locationRegion,
    String? locationCountry,
    double? latitude,
    double? longitude,
    required Map<String, dynamic> requirements,
  }) = _JobDraft;

  factory JobDraft.fromJson(Map<String, dynamic> json) => _$JobDraftFromJson(json);

  const JobDraft._();

  bool get isStep1Valid => 
    title.isNotEmpty && 
    description.isNotEmpty;

  bool get isStep2Valid => 
    budgetMin > 0 &&
    (isFixedPrice || (budgetMax >= budgetMin));

  bool get isStep3Valid => 
    timelineStart.isBefore(timelineEnd);

  bool get isStep4Valid => 
    locationType != LocationType.remote || 
    (locationCity != null && locationCity!.isNotEmpty);

  bool get isStep5Valid => requirements.isNotEmpty;

  bool get isComplete => 
    isStep1Valid && isStep2Valid && isStep3Valid && isStep4Valid && isStep5Valid;
}

@freezed
class ApplicationInput with _$ApplicationInput {
  const factory ApplicationInput({
    required String jobId,
    required String coverLetter,
    required int proposedAmount,
    String? proposedTerms,
  }) = _ApplicationInput;

  factory ApplicationInput.fromJson(Map<String, dynamic> json) => _$ApplicationInputFromJson(json);

  const ApplicationInput._();

  bool get isValid => 
    coverLetter.isNotEmpty && 
    proposedAmount > 0;
}

// MARK: - Extensions
extension CurrencyExtension on Currency {
  String get symbol {
    switch (this) {
      case Currency.USD:
        return '\$';
      case Currency.EUR:
        return '€';
      case Currency.GBP:
        return '£';
      case Currency.CAD:
        return 'C\$';
      case Currency.AUD:
        return 'A\$';
    }
  }

  String get code {
    switch (this) {
      case Currency.USD:
        return 'USD';
      case Currency.EUR:
        return 'EUR';
      case Currency.GBP:
        return 'GBP';
      case Currency.CAD:
        return 'CAD';
      case Currency.AUD:
        return 'AUD';
    }
  }
}

extension JobStatusX on JobStatus {
  String get displayName {
    switch (this) {
      case JobStatus.open:
        return 'Open';
      case JobStatus.hiring:
        return 'Hiring';
      case JobStatus.closed:
        return 'Closed';
    }
  }

  bool get isOpen => this == JobStatus.open;
  bool get isHiring => this == JobStatus.hiring;
  bool get isClosed => this == JobStatus.closed;
}

extension LocationTypeX on LocationType {
  String get displayName {
    switch (this) {
      case LocationType.remote:
        return 'Remote';
      case LocationType.onsite:
        return 'On-site';
      case LocationType.hybrid:
        return 'Hybrid';
    }
  }
}

extension ApplicationStatusX on ApplicationStatus {
  String get displayName {
    switch (this) {
      case ApplicationStatus.submitted:
        return 'Submitted';
      case ApplicationStatus.shortlisted:
        return 'Shortlisted';
      case ApplicationStatus.declined:
        return 'Declined';
      case ApplicationStatus.hired:
        return 'Hired';
    }
  }

  bool get isSubmitted => this == ApplicationStatus.submitted;
  bool get isShortlisted => this == ApplicationStatus.shortlisted;
  bool get isDeclined => this == ApplicationStatus.declined;
  bool get isHired => this == ApplicationStatus.hired;
}

extension JobX on Job {
  String get budgetDisplay {
    if (budgetMin == budgetMax) {
      return '\$${budgetMin.toStringAsFixed(0)}';
    }
    return '\$${budgetMin.toStringAsFixed(0)} - \$${budgetMax.toStringAsFixed(0)}';
  }

  String get locationDisplay {
    switch (locationType) {
      case LocationType.remote:
        return 'Remote';
      case LocationType.onsite:
        if (locationCity != null && locationCountry != null) {
          return '$locationCity, $locationCountry';
        } else if (locationCity != null) {
          return locationCity!;
        } else if (locationCountry != null) {
          return locationCountry!;
        }
        return 'On-site';
      case LocationType.hybrid:
        if (locationCity != null && locationCountry != null) {
          return 'Hybrid - $locationCity, $locationCountry';
        } else if (locationCity != null) {
          return 'Hybrid - $locationCity';
        } else if (locationCountry != null) {
          return 'Hybrid - $locationCountry';
        }
        return 'Hybrid';
    }
  }
}

// MARK: - Mock Data
extension JobMock on Job {
  static Job get mock => Job(
    id: 'job-1',
    clientId: 'client-1',
    title: 'Professional Product Photography',
    description: 'Looking for a skilled photographer to capture high-quality product images for our e-commerce store. Need 50+ products photographed with consistent lighting and styling.',
    budgetMin: 500,
    budgetMax: 1500,
    currency: Currency.USD,
    isFixedPrice: false,
    timelineStart: DateTime.now().add(const Duration(days: 7)),
    timelineEnd: DateTime.now().add(const Duration(days: 21)),
    locationType: LocationType.onsite,
    locationCity: 'Los Angeles',
    locationRegion: 'CA',
    locationCountry: 'USA',
    latitude: 34.0522,
    longitude: -118.2437,
    requirements: {
      'skills': ['Product Photography', 'Lighting', 'Post-processing'],
      'gear': ['Professional Camera', 'Studio Lighting', 'Tripod'],
      'notes': 'Must have portfolio of product photography work'
    },
    status: JobStatus.open,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
  );

  static List<Job> get mockList => [
    mock,
    Job(
      id: 'job-2',
      clientId: 'client-2',
      title: 'Corporate Event Videography',
      description: 'Need a videographer for our annual company conference. 2-day event with keynote speakers and breakout sessions.',
      budgetMin: 2000,
      budgetMax: 3500,
      currency: Currency.USD,
      isFixedPrice: false,
      timelineStart: DateTime.now().add(const Duration(days: 14)),
      timelineEnd: DateTime.now().add(const Duration(days: 15)),
      locationType: LocationType.onsite,
      locationCity: 'New York',
      locationRegion: 'NY',
      locationCountry: 'USA',
      requirements: {
        'skills': ['Event Videography', 'Multi-camera Setup', 'Live Streaming'],
        'gear': ['4K Camera', 'Gimbal', 'Wireless Audio'],
        'notes': 'Experience with corporate events preferred'
      },
      status: JobStatus.open,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Job(
      id: 'job-3',
      clientId: 'client-3',
      title: 'Fashion Model for Brand Campaign',
      description: 'Seeking a professional model for our upcoming fashion brand campaign. Various looks and styles needed.',
      budgetMin: 800,
      budgetMax: 800,
      currency: Currency.USD,
      isFixedPrice: true,
      timelineStart: DateTime.now().add(const Duration(days: 10)),
      timelineEnd: DateTime.now().add(const Duration(days: 10)),
      locationType: LocationType.onsite,
      locationCity: 'Miami',
      locationRegion: 'FL',
      locationCountry: 'USA',
      requirements: {
        'skills': ['Fashion Modeling', 'Pose Variety', 'Professional Demeanor'],
        'gear': ['Professional Wardrobe', 'Makeup Ready'],
        'notes': 'Must have modeling portfolio and agency representation'
      },
      status: JobStatus.hiring,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}

extension ApplicationMock on Application {
  static Application get mock => Application(
    id: 'app-1',
    jobId: 'job-1',
    creatorId: 'creator-1',
    coverLetter: 'I have 5+ years of experience in product photography and have worked with major brands. I specialize in creating compelling product images that drive sales.',
    proposedAmount: 1200,
    proposedTerms: 'I can complete the project within 2 weeks and provide 3 rounds of revisions.',
    status: ApplicationStatus.submitted,
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
  );

  static List<Application> get mockList => [
    mock,
    Application(
      id: 'app-2',
      jobId: 'job-1',
      creatorId: 'creator-2',
      coverLetter: 'Experienced product photographer with studio setup. I can deliver high-quality images with quick turnaround.',
      proposedAmount: 1000,
      proposedTerms: '1 week delivery, 2 rounds of revisions included.',
      status: ApplicationStatus.shortlisted,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}
