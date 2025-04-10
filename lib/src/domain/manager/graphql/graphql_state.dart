// States
import '../../../data/export.dart';

abstract class GraphQLState {}

class GraphQLInitial extends GraphQLState {}

class GraphQLLoading extends GraphQLState {}

class GraphQLLoaded extends GraphQLState {
  final List<Post> posts;

  GraphQLLoaded({required this.posts});
}

class GraphQLErrors extends GraphQLState {
  final String message;

  GraphQLErrors({required this.message});
}

