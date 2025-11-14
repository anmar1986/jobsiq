import 'package:equatable/equatable.dart';

abstract class CvsEvent extends Equatable {
  const CvsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCvsEvent extends CvsEvent {
  const LoadCvsEvent();
}

class DeleteCvEvent extends CvsEvent {
  final int cvId;

  const DeleteCvEvent(this.cvId);

  @override
  List<Object?> get props => [cvId];
}

class SetPrimaryCvEvent extends CvsEvent {
  final int cvId;

  const SetPrimaryCvEvent(this.cvId);

  @override
  List<Object?> get props => [cvId];
}
