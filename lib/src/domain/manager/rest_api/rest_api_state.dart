// States
import '../../../data/export.dart';

abstract class RestApiState {}

class RestApiInitial extends RestApiState {}

class RestApiLoading extends RestApiState {}

class RestApiLoaded extends RestApiState {
  final List<User> users;

  RestApiLoaded({required this.users});
}

class RestApiError extends RestApiState {
  final String message;

  RestApiError({required this.message});
}