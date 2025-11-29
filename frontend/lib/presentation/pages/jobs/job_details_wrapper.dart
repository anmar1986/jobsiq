import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/di/injection.dart';
import '../../../domain/entities/job_entity.dart';
import '../../bloc/jobs/jobs_bloc.dart';
import '../../bloc/jobs/jobs_event.dart';
import '../../bloc/jobs/jobs_state.dart';
import 'job_details_page.dart';

/// Wrapper that fetches job by slug if not provided via extra
class JobDetailsWrapper extends StatelessWidget {
  final String slug;
  final JobEntity? job;

  const JobDetailsWrapper({
    super.key,
    required this.slug,
    this.job,
  });

  @override
  Widget build(BuildContext context) {
    // If job is already provided, show it directly
    if (job != null) {
      return JobDetailsPage(job: job!);
    }

    // Otherwise, fetch the job by slug
    return BlocProvider(
      create: (_) => getIt<JobsBloc>()..add(LoadJobBySlugEvent(slug)),
      child: BlocBuilder<JobsBloc, JobsState>(
        builder: (context, state) {
          if (state is JobsLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is JobLoaded) {
            return JobDetailsPage(job: state.job);
          }

          if (state is JobsError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Job Not Found')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Scaffold(
            body: Center(
              child: Text('Loading...'),
            ),
          );
        },
      ),
    );
  }
}
