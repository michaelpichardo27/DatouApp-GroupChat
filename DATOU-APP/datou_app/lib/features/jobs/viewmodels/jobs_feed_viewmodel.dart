import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/job_models.dart';
import '../services/jobs_service.dart';

// MARK: - Service Provider
final jobsServiceProvider = Provider<JobsService>((ref) {
  return JobsService();
});

// MARK: - Jobs Feed Provider
final jobsFeedProvider = StateNotifierProvider<JobsFeedNotifier, AsyncValue<List<Job>>>((ref) {
  final service = ref.watch(jobsServiceProvider);
  return JobsFeedNotifier(service);
});

class JobsFeedNotifier extends StateNotifier<AsyncValue<List<Job>>> {
  final JobsService _service;
  
  JobsFeedNotifier(this._service) : super(const AsyncValue.loading()) {
    loadJobs();
  }
  
  Future<void> loadJobs({
    JobStatus? status,
    String? search,
    int? limit,
    int? offset,
  }) async {
    try {
      state = const AsyncValue.loading();
      final jobs = await _service.fetchJobsFeed(
        status: status,
        search: search,
        limit: limit,
        offset: offset,
      );
      state = AsyncValue.data(jobs);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
  
  Future<void> refresh() async {
    await loadJobs();
  }
  
  bool get hasMoreData => state.value?.length == 20; // Assuming 20 is the default limit
}

// MARK: - My Jobs Provider
final myJobsProvider = StateNotifierProvider.family<MyJobsNotifier, AsyncValue<List<Job>>, JobStatus>((ref, status) {
  final service = ref.watch(jobsServiceProvider);
  return MyJobsNotifier(service, status);
});

class MyJobsNotifier extends StateNotifier<AsyncValue<List<Job>>> {
  final JobsService _service;
  final JobStatus _status;
  
  MyJobsNotifier(this._service, this._status) : super(const AsyncValue.loading()) {
    loadJobs();
  }
  
  Future<void> loadJobs() async {
    try {
      state = const AsyncValue.loading();
      final jobs = await _service.fetchMyJobs([_status]);
      state = AsyncValue.data(jobs);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
  
  Future<void> refresh() async {
    await loadJobs();
  }
  
  Future<void> closeJob(String jobId) async {
    try {
      await _service.closeJob(jobId);
      await loadJobs(); // Refresh the list
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
  
  Future<void> reopenJob(String jobId) async {
    try {
      await _service.reopenJob(jobId);
      await loadJobs(); // Refresh the list
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
  
  Future<void> deleteJob(String jobId) async {
    try {
      await _service.deleteJob(jobId);
      await loadJobs(); // Refresh the list
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}

// MARK: - Job Detail Provider
final jobDetailProvider = StateNotifierProvider.family<JobDetailNotifier, AsyncValue<Job?>, String>((ref, jobId) {
  final service = ref.watch(jobsServiceProvider);
  return JobDetailNotifier(service, jobId);
});

class JobDetailNotifier extends StateNotifier<AsyncValue<Job?>> {
  final JobsService _service;
  final String _jobId;
  
  JobDetailNotifier(this._service, this._jobId) : super(const AsyncValue.loading()) {
    loadJob();
  }
  
  Future<void> loadJob() async {
    try {
      state = const AsyncValue.loading();
      final job = await _service.fetchJob(_jobId);
      state = AsyncValue.data(job);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
  
  Future<void> refresh() async {
    await loadJob();
  }
  
  Future<void> updateJob(Job job) async {
    try {
      final updatedJob = await _service.updateJob(job);
      state = AsyncValue.data(updatedJob);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}

// MARK: - Applicants Provider
final applicantsProvider = StateNotifierProvider.family<ApplicantsNotifier, AsyncValue<List<Application>>, String>((ref, jobId) {
  final service = ref.watch(jobsServiceProvider);
  return ApplicantsNotifier(service, jobId);
});

class ApplicantsNotifier extends StateNotifier<AsyncValue<List<Application>>> {
  final JobsService _service;
  final String _jobId;
  
  ApplicantsNotifier(this._service, this._jobId) : super(const AsyncValue.loading()) {
    loadApplicants();
  }
  
  Future<void> loadApplicants() async {
    try {
      state = const AsyncValue.loading();
      final applicants = await _service.fetchApplicants(_jobId);
      state = AsyncValue.data(applicants);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
  
  Future<void> refresh() async {
    await loadApplicants();
  }
  
  Future<void> shortlistApplication(String applicationId) async {
    try {
      await _service.shortlistApplication(applicationId);
      await loadApplicants(); // Refresh the list
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
  
  Future<void> declineApplication(String applicationId) async {
    try {
      await _service.declineApplication(applicationId);
      await loadApplicants(); // Refresh the list
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
  
  Future<void> hireApplication(String applicationId, int agreedAmount, String agreedTerms) async {
    try {
      await _service.confirmHire(
        jobId: _jobId,
        applicationId: applicationId,
        agreedAmount: agreedAmount,
        agreedTerms: agreedTerms,
      );
      await loadApplicants(); // Refresh the list
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}

// MARK: - Hire Provider
final hireProvider = StateNotifierProvider.family<HireNotifier, AsyncValue<Hire?>, String>((ref, jobId) {
  final service = ref.watch(jobsServiceProvider);
  return HireNotifier(service, jobId);
});

class HireNotifier extends StateNotifier<AsyncValue<Hire?>> {
  final JobsService _service;
  final String _jobId;
  
  HireNotifier(this._service, this._jobId) : super(const AsyncValue.loading()) {
    loadHire();
  }
  
  Future<void> loadHire() async {
    try {
      state = const AsyncValue.loading();
      final hire = await _service.fetchHire(_jobId);
      state = AsyncValue.data(hire);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
  
  Future<void> refresh() async {
    await loadHire();
  }
}

// MARK: - Application Filters and Sorting
enum ApplicationSortBy {
  rating,
  price,
  recency,
}

class ApplicationFilters {
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool verifiedOnly;
  final ApplicationSortBy sortBy;

  const ApplicationFilters({
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.verifiedOnly = false,
    this.sortBy = ApplicationSortBy.recency,
  });

  ApplicationFilters copyWith({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? verifiedOnly,
    ApplicationSortBy? sortBy,
  }) {
    return ApplicationFilters(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

// MARK: - Filtered Applicants Provider
final filteredApplicantsProvider = StateNotifierProvider.family<FilteredApplicantsNotifier, AsyncValue<List<Application>>, String>((ref, jobId) {
  final applicantsState = ref.watch(applicantsProvider(jobId));
  return FilteredApplicantsNotifier(applicantsState);
});

class FilteredApplicantsNotifier extends StateNotifier<AsyncValue<List<Application>>> {
  FilteredApplicantsNotifier(AsyncValue<List<Application>> applicantsState) : super(applicantsState) {
    _filterAndSort(applicantsState.value ?? []);
  }

  void _filterAndSort(List<Application> applicants) {
    // Apply filters
    var filtered = applicants.where((app) {
      // Price filter
      if (app.proposedAmount < 0) return false; // Basic validation
      
      // Rating filter (TODO: Implement when creator rating is available)
      // if (minRating != null && app.creator.rating < minRating) return false;
      
      // Verified filter (TODO: Implement when creator verification is available)
      // if (verifiedOnly && !app.creator.isVerified) return false;
      
      return true;
    }).toList();

    // Apply sorting
    filtered.sort((a, b) {
      switch (ApplicationSortBy.recency) { // TODO: Use actual sortBy
        case ApplicationSortBy.recency:
          return b.createdAt.compareTo(a.createdAt);
        case ApplicationSortBy.price:
          return a.proposedAmount.compareTo(b.proposedAmount);
        case ApplicationSortBy.rating:
          // TODO: Sort by creator rating
          return 0;
      }
    });

    state = AsyncValue.data(filtered);
  }

  void updateFilters(ApplicationFilters filters) {
    final currentApplicants = state.value ?? [];
    _filterAndSort(currentApplicants);
  }
}
