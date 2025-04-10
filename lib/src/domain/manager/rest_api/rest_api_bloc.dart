// BLoC
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../data/export.dart';
import '../export.dart';

class RestApiBloc extends Bloc<RestApiEvent, RestApiState> {
  final String apiUrl = 'https://jsonplaceholder.typicode.com/users';
  
  RestApiBloc() : super(RestApiInitial()) {
    on<FetchUsers>(_onFetchUsers);
  }

  void _onFetchUsers(FetchUsers event, Emitter<RestApiState> emit) async {
    emit(RestApiLoading());
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> usersJson = json.decode(response.body);
        final users = usersJson.map((json) => User.fromJson(json)).toList();
        emit(RestApiLoaded(users: users));
      } else {
        emit(RestApiError(message: 'Failed to load users: ${response.statusCode}'));
      }
    } catch (e) {
      emit(RestApiError(message: 'Error fetching users: $e'));
    }
  }
}