import 'package:equatable/equatable.dart';
import '../../../domain/entities/cv_entity.dart';

abstract class CvsState extends Equatable {
  const CvsState();

  @override
  List<Object?> get props => [];
}

class CvsInitial extends CvsState {
  const CvsInitial();
}

class CvsLoading extends CvsState {
  const CvsLoading();
}

class CvsLoaded extends CvsState {
  final List<CvEntity> cvs;

  const CvsLoaded(this.cvs);

  @override
  List<Object?> get props => [cvs];

  CvsLoaded copyWith({List<CvEntity>? cvs}) {
    return CvsLoaded(cvs ?? this.cvs);
  }
}

class CvsEmpty extends CvsState {
  const CvsEmpty();
}

class CvsError extends CvsState {
  final String message;

  const CvsError(this.message);

  @override
  List<Object?> get props => [message];
}

class CvDeleting extends CvsState {
  final int cvId;
  final List<CvEntity> cvs;

  const CvDeleting(this.cvId, this.cvs);

  @override
  List<Object?> get props => [cvId, cvs];
}

class CvSettingPrimary extends CvsState {
  final int cvId;
  final List<CvEntity> cvs;

  const CvSettingPrimary(this.cvId, this.cvs);

  @override
  List<Object?> get props => [cvId, cvs];
}
