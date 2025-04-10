// BLoC
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../data/export.dart';
import '../export.dart';

class GraphQLBloc extends Bloc<GraphQLEvent, GraphQLState> {
  final GraphQLClient client;
  
  GraphQLBloc({required this.client}) : super(GraphQLInitial()) {
    on<FetchPosts>(_onFetchPosts);
  }

  void _onFetchPosts(FetchPosts event, Emitter<GraphQLState> emit) async {
    emit(GraphQLLoading());
    try {
      const String query = '''
        query GetPosts {
          posts {
            data {
              id
              title
              body
            }
          }
        }
      ''';

      final QueryOptions options = QueryOptions(
        document: gql(query),
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        emit(GraphQLErrors(message: 'Error fetching posts: ${result.exception}'));
        return;
      }

      final List<dynamic> postsJson = result.data?['posts']['data'];
      final posts = postsJson.map((json) => Post.fromJson(json)).toList();
      
      emit(GraphQLLoaded(posts: posts));
    } catch (e) {
      emit(GraphQLErrors(message: 'Error in GraphQL query: $e'));
    }
  }
}