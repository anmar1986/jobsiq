import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/cv_remote_data_source.dart';
import 'cvs_event.dart';
import 'cvs_state.dart';

class CvsBloc extends Bloc<CvsEvent, CvsState> {
  final CvRemoteDataSource cvDataSource;

  CvsBloc({required this.cvDataSource}) : super(const CvsInitial()) {
    on<LoadCvsEvent>(_onLoadCvs);
    on<DeleteCvEvent>(_onDeleteCv);
    on<SetPrimaryCvEvent>(_onSetPrimaryCv);
  }

  Future<void> _onLoadCvs(LoadCvsEvent event, Emitter<CvsState> emit) async {
    emit(const CvsLoading());

    try {
      final cvs = await cvDataSource.getMyCvs();

      if (cvs.isEmpty) {
        emit(const CvsEmpty());
      } else {
        emit(CvsLoaded(cvs));
      }
    } catch (e) {
      final errorMessage = e.toString().contains('401')
          ? 'Please login to view your CVs'
          : 'Failed to load CVs. Please try again.';
      emit(CvsError(errorMessage));
    }
  }

  Future<void> _onDeleteCv(DeleteCvEvent event, Emitter<CvsState> emit) async {
    final currentState = state;
    if (currentState is! CvsLoaded) return;

    emit(CvDeleting(event.cvId, currentState.cvs));

    try {
      await cvDataSource.deleteCv(event.cvId);

      // Remove the deleted CV from the list
      final updatedCvs = currentState.cvs
          .where((cv) => cv.id != event.cvId)
          .toList();

      if (updatedCvs.isEmpty) {
        emit(const CvsEmpty());
      } else {
        emit(CvsLoaded(updatedCvs));
      }
    } catch (e) {
      final errorMessage = e.toString().contains('401')
          ? 'Please login to delete CVs'
          : 'Failed to delete CV. Please try again.';
      emit(CvsError(errorMessage));

      // Reload CVs after error
      add(const LoadCvsEvent());
    }
  }

  Future<void> _onSetPrimaryCv(
      SetPrimaryCvEvent event, Emitter<CvsState> emit) async {
    final currentState = state;
    if (currentState is! CvsLoaded) return;

    emit(CvSettingPrimary(event.cvId, currentState.cvs));

    try {
      await cvDataSource.setPrimaryCv(event.cvId);

      // Reload CVs to reflect the primary change
      add(const LoadCvsEvent());
    } catch (e) {
      final errorMessage = e.toString().contains('401')
          ? 'Please login to set primary CV'
          : 'Failed to set primary CV. Please try again.';
      emit(CvsError(errorMessage));

      // Reload CVs after error
      add(const LoadCvsEvent());
    }
  }
}
