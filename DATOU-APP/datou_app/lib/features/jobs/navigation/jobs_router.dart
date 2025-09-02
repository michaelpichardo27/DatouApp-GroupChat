import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/job_models.dart';
import '../views/jobs_feed_view.dart';
import '../views/job_detail_view.dart';
import '../views/post_job_flow_view.dart';
import '../views/manage_my_jobs_view.dart';
import '../views/applicants_list_view.dart';
import '../views/hire_confirmation_view.dart';
import '../views/job_settings_view.dart';

// MARK: - Route Names
class JobsRoutes {
  static const String feed = '/listings/jobs';
  static const String detail = '/listings/jobs/detail';
  static const String postJob = '/listings/jobs/post';
  static const String manage = '/listings/jobs/manage';
  static const String applicants = '/listings/jobs/applicants';
  static const String hire = '/listings/jobs/hire';
  static const String settings = '/listings/jobs/settings';
}

// MARK: - Router Configuration
class JobsRouter {
  static List<RouteBase> get routes => [
    GoRoute(
      path: JobsRoutes.feed,
      name: 'jobs_feed',
      builder: (context, state) => const JobsFeedView(),
    ),
    GoRoute(
      path: '${JobsRoutes.detail}/:id',
      name: 'job_detail',
      builder: (context, state) {
        final jobId = state.pathParameters['id']!;
        return JobDetailView(jobId: jobId);
      },
    ),
    GoRoute(
      path: JobsRoutes.postJob,
      name: 'post_job',
      builder: (context, state) => const PostJobFlowView(),
    ),
    GoRoute(
      path: JobsRoutes.manage,
      name: 'manage_jobs',
      builder: (context, state) => const ManageMyJobsView(),
    ),
    GoRoute(
      path: '${JobsRoutes.applicants}/:jobId',
      name: 'applicants_list',
      builder: (context, state) {
        final jobId = state.pathParameters['jobId']!;
        return ApplicantsListView(jobId: jobId);
      },
    ),
    GoRoute(
      path: '${JobsRoutes.hire}/:jobId/:applicationId?',
      name: 'hire_confirmation',
      builder: (context, state) {
        final jobId = state.pathParameters['jobId']!;
        final applicationId = state.pathParameters['applicationId'];
        return HireConfirmationView(
          jobId: jobId,
          applicationId: applicationId,
        );
      },
    ),
    GoRoute(
      path: '${JobsRoutes.settings}/:jobId',
      name: 'job_settings',
      builder: (context, state) {
        final jobId = state.pathParameters['jobId']!;
        return JobSettingsView(jobId: jobId);
      },
    ),
  ];

  // MARK: - Navigation Helpers
  static void goToFeed(BuildContext context) {
    context.go(JobsRoutes.feed);
  }

  static void goToDetail(BuildContext context, String jobId) {
    context.go('${JobsRoutes.detail}/$jobId');
  }

  static void goToPostJob(BuildContext context) {
    context.go(JobsRoutes.postJob);
  }

  static void goToManage(BuildContext context) {
    context.go(JobsRoutes.manage);
  }

  static void goToApplicants(BuildContext context, String jobId) {
    context.go('${JobsRoutes.applicants}/$jobId');
  }

  static void goToHire(BuildContext context, String jobId, {String? applicationId}) {
    if (applicationId != null) {
      context.go('${JobsRoutes.hire}/$jobId/$applicationId');
    } else {
      context.go('${JobsRoutes.hire}/$jobId');
    }
  }

  static void goToSettings(BuildContext context, String jobId) {
    context.go('${JobsRoutes.settings}/$jobId');
  }

  // MARK: - Push Navigation (for modals/overlays)
  static void pushToDetail(BuildContext context, String jobId) {
    context.push('${JobsRoutes.detail}/$jobId');
  }

  static void pushToPostJob(BuildContext context) {
    context.push(JobsRoutes.postJob);
  }

  static void pushToApplicants(BuildContext context, String jobId) {
    context.push('${JobsRoutes.applicants}/$jobId');
  }

  static void pushToHire(BuildContext context, String jobId, {String? applicationId}) {
    if (applicationId != null) {
      context.push('${JobsRoutes.hire}/$jobId/$applicationId');
    } else {
      context.push('${JobsRoutes.hire}/$jobId');
    }
  }

  static void pushToSettings(BuildContext context, String jobId) {
    context.push('${JobsRoutes.settings}/$jobId');
  }

  // MARK: - Replace Navigation
  static void replaceWithDetail(BuildContext context, String jobId) {
    context.replace('${JobsRoutes.detail}/$jobId');
  }

  static void replaceWithManage(BuildContext context) {
    context.replace(JobsRoutes.manage);
  }

  // MARK: - Pop Navigation
  static void pop(BuildContext context, [dynamic result]) {
    context.pop(result);
  }

  static void popToRoot(BuildContext context) {
    context.go(JobsRoutes.feed);
  }

  // MARK: - Query Parameters
  static Map<String, String> getQueryParams({
    JobStatus? status,
    String? search,
    String? location,
    int? minBudget,
    int? maxBudget,
  }) {
    final params = <String, String>{};
    
    if (status != null) params['status'] = status.name;
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (location != null && location.isNotEmpty) params['location'] = location;
    if (minBudget != null) params['min_budget'] = minBudget.toString();
    if (maxBudget != null) params['max_budget'] = maxBudget.toString();
    
    return params;
  }

  static void goToFeedWithFilters(
    BuildContext context, {
    JobStatus? status,
    String? search,
    String? location,
    int? minBudget,
    int? maxBudget,
  }) {
    final params = getQueryParams(
      status: status,
      search: search,
      location: location,
      minBudget: minBudget,
      maxBudget: maxBudget,
    );
    
    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    
    final path = queryString.isNotEmpty 
        ? '${JobsRoutes.feed}?$queryString'
        : JobsRoutes.feed;
    
    context.go(path);
  }
}

// MARK: - Route Extensions
extension JobsRouteExtension on BuildContext {
  void goToJobsFeed() => JobsRouter.goToFeed(this);
  void goToJobDetail(String jobId) => JobsRouter.goToDetail(this, jobId);
  void goToPostJob() => JobsRouter.goToPostJob(this);
  void goToManageJobs() => JobsRouter.goToManage(this);
  void goToApplicants(String jobId) => JobsRouter.goToApplicants(this, jobId);
  void goToHire(String jobId, {String? applicationId}) => JobsRouter.goToHire(this, jobId, applicationId: applicationId);
  void goToJobSettings(String jobId) => JobsRouter.goToSettings(this, jobId);
  
  void pushToJobDetail(String jobId) => JobsRouter.pushToDetail(this, jobId);
  void pushToPostJob() => JobsRouter.pushToPostJob(this);
  void pushToApplicants(String jobId) => JobsRouter.pushToApplicants(this, jobId);
  void pushToHire(String jobId, {String? applicationId}) => JobsRouter.pushToHire(this, jobId, applicationId: applicationId);
  void pushToJobSettings(String jobId) => JobsRouter.pushToSettings(this, jobId);
  
  void replaceWithJobDetail(String jobId) => JobsRouter.replaceWithDetail(this, jobId);
  void replaceWithManageJobs() => JobsRouter.replaceWithManage(this);
  
  void popJobs([dynamic result]) => JobsRouter.pop(this, result);
  void popToJobsRoot() => JobsRouter.popToRoot(this);
}
