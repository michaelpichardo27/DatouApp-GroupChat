import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/job_models.dart';

// MARK: - Service Interface
abstract class JobsServicing {
  Future<List<Job>> fetchJobsFeed({
    JobStatus? status,
    String? search,
    int? limit,
    int? offset,
  });
  
  Future<Job> fetchJob(String id);
  Future<Job> createJob(JobDraft draft);
  Future<Job> updateJob(Job job);
  Future<void> closeJob(String id);
  Future<void> reopenJob(String id);
  Future<void> deleteJob(String id);
  Future<List<Job>> fetchMyJobs(List<JobStatus> statuses);
  
  Future<List<Application>> fetchApplicants(String jobId);
  Future<Application> submitApplication(ApplicationInput input);
  Future<Application> updateApplicationStatus(String id, ApplicationStatus status);
  Future<Application> shortlistApplication(String id);
  Future<Application> declineApplication(String id);
  
  Future<Hire> confirmHire({
    required String jobId,
    required String applicationId,
    required int agreedAmount,
    required String agreedTerms,
  });
  
  Future<Hire?> fetchHire(String jobId);
}

// MARK: - Error Types
enum JobsErrorType {
  network,
  unauthorized,
  notFound,
  validation,
  server,
  unknown,
}

class JobsError implements Exception {
  final JobsErrorType type;
  final String message;
  final String? details;
  final dynamic originalError;

  const JobsError({
    required this.type,
    required this.message,
    this.details,
    this.originalError,
  });

  @override
  String toString() => 'JobsError($type): $message${details != null ? ' - $details' : ''}';

  String get userFriendlyMessage {
    switch (type) {
      case JobsErrorType.network:
        return 'Connection error. Please check your internet and try again.';
      case JobsErrorType.unauthorized:
        return 'Please sign in to continue.';
      case JobsErrorType.notFound:
        return 'The requested job was not found.';
      case JobsErrorType.validation:
        return 'Please check your input and try again.';
      case JobsErrorType.server:
        return 'Server error. Please try again later.';
      case JobsErrorType.unknown:
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

// MARK: - Supabase Implementation
class JobsService implements JobsServicing {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<Job>> fetchJobsFeed({
    JobStatus? status,
    String? search,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = _supabase
          .from('jobs')
          .select('''
            *,
            client:profiles!jobs_client_id_fkey(
              id,
              full_name,
              username,
              avatar_url,
              rating,
              is_verified
            )
          ''')
          .eq('is_active', true);

      if (status != null) {
        query = query.eq('status', status.name);
      }

      if (search != null && search.isNotEmpty) {
        query = query.textSearch('title', search);
      }

      final response = await query
          .limit(limit ?? 20)
          .range(offset ?? 0, (offset ?? 0) + (limit ?? 20) - 1)
          .order('created_at', ascending: false);
      return (response as List).map((json) => Job.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Job> fetchJob(String id) async {
    try {
      final response = await _supabase
          .from('jobs')
          .select('''
            *,
            client:profiles!jobs_client_id_fkey(
              id,
              full_name,
              username,
              avatar_url,
              rating,
              is_verified
            )
          ''')
          .eq('id', id)
          .eq('is_active', true)
          .single();

      return Job.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Job> createJob(JobDraft draft) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'User not authenticated',
        );
      }

      final jobData = {
        'client_id': user.id,
        'title': draft.title,
        'description': draft.description,
        'budget_min': draft.budgetMin,
        'budget_max': draft.budgetMax,
        'currency': draft.currency.name,
        'is_fixed_price': draft.isFixedPrice,
        'timeline_start': draft.timelineStart.toIso8601String(),
        'timeline_end': draft.timelineEnd.toIso8601String(),
        'location_type': draft.locationType.name,
        'location_city': draft.locationCity,
        'location_region': draft.locationRegion,
        'location_country': draft.locationCountry,
        'latitude': draft.latitude,
        'longitude': draft.longitude,
        'requirements': draft.requirements,
      };

      final response = await _supabase
          .from('jobs')
          .insert(jobData)
          .select('''
            *,
            client:profiles!jobs_client_id_fkey(
              id,
              full_name,
              username,
              avatar_url,
              rating,
              is_verified
            )
          ''')
          .single();

      return Job.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Job> updateJob(Job job) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'User not authenticated',
        );
      }

      final jobData = {
        'title': job.title,
        'description': job.description,
        'budget_min': job.budgetMin,
        'budget_max': job.budgetMax,
        'currency': job.currency.name,
        'is_fixed_price': job.isFixedPrice,
        'timeline_start': job.timelineStart.toIso8601String(),
        'timeline_end': job.timelineEnd.toIso8601String(),
        'location_type': job.locationType.name,
        'location_city': job.locationCity,
        'location_region': job.locationRegion,
        'location_country': job.locationCountry,
        'latitude': job.latitude,
        'longitude': job.longitude,
        'requirements': job.requirements,
        'status': job.status.name,
      };

      final response = await _supabase
          .from('jobs')
          .update(jobData)
          .eq('id', job.id)
          .eq('client_id', user.id)
          .select('''
            *,
            client:profiles!jobs_client_id_fkey(
              id,
              full_name,
              username,
              avatar_url,
              rating,
              is_verified
            )
          ''')
          .single();

      return Job.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> closeJob(String id) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'User not authenticated',
        );
      }

      await _supabase
          .from('jobs')
          .update({'status': 'closed'})
          .eq('id', id)
          .eq('client_id', user.id);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> reopenJob(String id) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'User not authenticated',
        );
      }

      await _supabase
          .from('jobs')
          .update({'status': 'open'})
          .eq('id', id)
          .eq('client_id', user.id);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteJob(String id) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'User not authenticated',
        );
      }

      // Soft delete by setting is_active to false
      await _supabase
          .from('jobs')
          .update({'is_active': false})
          .eq('id', id)
          .eq('client_id', user.id);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<Job>> fetchMyJobs(List<JobStatus> statuses) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'User not authenticated',
        );
      }

      var query = _supabase
          .from('jobs')
          .select('''
            *,
            client:profiles!jobs_client_id_fkey(
              id,
              full_name,
              username,
              avatar_url,
              rating,
              is_verified
            )
          ''')
          .eq('client_id', user.id)
          .eq('is_active', true);

      if (statuses.isNotEmpty) {
        query = query.inFilter('status', statuses.map((s) => s.name).toList());
      }

      final response = await query.order('created_at', ascending: false);
      return (response as List).map((json) => Job.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<Application>> fetchApplicants(String jobId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'User not authenticated',
        );
      }

      // Verify the user owns this job
      final jobResponse = await _supabase
          .from('jobs')
          .select('client_id')
          .eq('id', jobId)
          .single();

      if (jobResponse['client_id'] != user.id) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'You can only view applicants for your own jobs',
        );
      }

      final response = await _supabase
          .from('applications')
          .select('''
            *,
            creator:profiles!applications_creator_id_fkey(
              id,
              full_name,
              username,
              avatar_url,
              rating,
              is_verified,
              bio,
              portfolio_url
            )
          ''')
          .eq('job_id', jobId)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Application.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Application> submitApplication(ApplicationInput input) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'User not authenticated',
        );
      }

      final applicationData = {
        'job_id': input.jobId,
        'creator_id': user.id,
        'cover_letter': input.coverLetter,
        'proposed_amount': input.proposedAmount,
        'proposed_terms': input.proposedTerms,
      };

      final response = await _supabase
          .from('applications')
          .insert(applicationData)
          .select('''
            *,
            creator:profiles!applications_creator_id_fkey(
              id,
              full_name,
              username,
              avatar_url,
              rating,
              is_verified,
              bio,
              portfolio_url
            )
          ''')
          .single();

      return Application.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Application> updateApplicationStatus(String id, ApplicationStatus status) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'User not authenticated',
        );
      }

      // Verify the user owns the job for this application
      final applicationResponse = await _supabase
          .from('applications')
          .select('job_id')
          .eq('id', id)
          .single();

      final jobResponse = await _supabase
          .from('jobs')
          .select('client_id')
          .eq('id', applicationResponse['job_id'])
          .single();

      if (jobResponse['client_id'] != user.id) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'You can only update applications for your own jobs',
        );
      }

      final response = await _supabase
          .from('applications')
          .update({'status': status.name})
          .eq('id', id)
          .select('''
            *,
            creator:profiles!applications_creator_id_fkey(
              id,
              full_name,
              username,
              avatar_url,
              rating,
              is_verified,
              bio,
              portfolio_url
            )
          ''')
          .single();

      return Application.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Application> shortlistApplication(String id) async {
    return updateApplicationStatus(id, ApplicationStatus.shortlisted);
  }

  @override
  Future<Application> declineApplication(String id) async {
    return updateApplicationStatus(id, ApplicationStatus.declined);
  }

  @override
  Future<Hire> confirmHire({
    required String jobId,
    required String applicationId,
    required int agreedAmount,
    required String agreedTerms,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'User not authenticated',
        );
      }

      // Verify the user owns the job
      final jobResponse = await _supabase
          .from('jobs')
          .select('client_id')
          .eq('id', jobId)
          .single();

      if (jobResponse['client_id'] != user.id) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'You can only hire for your own jobs',
        );
      }

      // Verify the application exists and belongs to this job
      final applicationResponse = await _supabase
          .from('applications')
          .select('id')
          .eq('id', applicationId)
          .eq('job_id', jobId)
          .single();

      final hireData = {
        'job_id': jobId,
        'application_id': applicationId,
        'agreed_amount': agreedAmount,
        'agreed_terms': agreedTerms,
      };

      final response = await _supabase
          .from('hires')
          .insert(hireData)
          .select('''
            *,
            application:applications!hires_application_id_fkey(
              *,
              creator:profiles!applications_creator_id_fkey(
                id,
                full_name,
                username,
                avatar_url,
                rating,
                is_verified
              )
            )
          ''')
          .single();

      return Hire.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Hire?> fetchHire(String jobId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'User not authenticated',
        );
      }

      // Verify the user owns the job
      final jobResponse = await _supabase
          .from('jobs')
          .select('client_id')
          .eq('id', jobId)
          .single();

      if (jobResponse['client_id'] != user.id) {
        throw const JobsError(
          type: JobsErrorType.unauthorized,
          message: 'You can only view hires for your own jobs',
        );
      }

      final response = await _supabase
          .from('hires')
          .select('''
            *,
            application:applications!hires_application_id_fkey(
              *,
              creator:profiles!applications_creator_id_fkey(
                id,
                full_name,
                username,
                avatar_url,
                rating,
                is_verified
              )
            )
          ''')
          .eq('job_id', jobId)
          .maybeSingle();

      if (response == null) return null;
      return Hire.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  JobsError _handleError(dynamic error) {
    if (error is PostgrestException) {
      switch (error.code) {
        case 'PGRST116':
          return JobsError(
            type: JobsErrorType.notFound,
            message: 'Resource not found',
            details: error.message,
          );
        case 'PGRST301':
          return JobsError(
            type: JobsErrorType.unauthorized,
            message: 'Unauthorized access',
            details: error.message,
          );
        case 'PGRST302':
          return JobsError(
            type: JobsErrorType.validation,
            message: 'Validation error',
            details: error.message,
          );
        default:
          return JobsError(
            type: JobsErrorType.server,
            message: 'Database error',
            details: error.message,
            originalError: error,
          );
      }
    } else if (error is AuthException) {
      return JobsError(
        type: JobsErrorType.unauthorized,
        message: 'Authentication error',
        details: error.message,
        originalError: error,
      );
    } else if (error is SocketException || error.toString().contains('network')) {
      return JobsError(
        type: JobsErrorType.network,
        message: 'Network error',
        details: error.toString(),
        originalError: error,
      );
    } else {
      return JobsError(
        type: JobsErrorType.unknown,
        message: 'Unknown error',
        details: error.toString(),
        originalError: error,
      );
    }
  }
}

// MARK: - Cache Implementation (keeping for offline support)
class JobsCache {
  static const String _cacheDir = 'jobs_cache';
  static const Duration _feedCacheDuration = Duration(minutes: 5);
  static const Duration _detailCacheDuration = Duration(minutes: 1);
  
  late final Directory _cacheDirectory;
  
  Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    _cacheDirectory = Directory('${appDir.path}/$_cacheDir');
    if (!await _cacheDirectory.exists()) {
      await _cacheDirectory.create(recursive: true);
    }
  }
  
  Future<void> cacheJobs(String key, List<Job> jobs) async {
    final file = File('${_cacheDirectory.path}/$key.json');
    final data = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'jobs': jobs.map((j) => j.toJson()).toList(),
    };
    await file.writeAsString(jsonEncode(data));
  }
  
  Future<List<Job>?> getCachedJobs(String key, Duration maxAge) async {
    try {
      final file = File('${_cacheDirectory.path}/$key.json');
      if (!await file.exists()) return null;
      
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;
      final timestamp = data['timestamp'] as int;
      final age = DateTime.now().millisecondsSinceEpoch - timestamp;
      
      if (age > maxAge.inMilliseconds) {
        await file.delete();
        return null;
      }
      
      final jobsJson = data['jobs'] as List;
      return jobsJson.map((j) => Job.fromJson(j)).toList();
    } catch (e) {
      return null;
    }
  }
  
  Future<void> clearCache() async {
    if (await _cacheDirectory.exists()) {
      await _cacheDirectory.delete(recursive: true);
    }
  }
}
