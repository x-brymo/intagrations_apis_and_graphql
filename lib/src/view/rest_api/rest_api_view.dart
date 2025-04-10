// screens/rest_api_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/export.dart';
import '../../domain/manager/export.dart';

class RestApiScreen extends StatefulWidget {
  const RestApiScreen({Key? key}) : super(key: key);

  @override
  _RestApiScreenState createState() => _RestApiScreenState();
}

class _RestApiScreenState extends State<RestApiScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RestApiBloc>().add(FetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API Integration'),
      ),
      body: BlocConsumer<RestApiBloc, RestApiState>(
        listener: (context, state) {
          if (state is RestApiError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is RestApiLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RestApiLoaded) {
            return _buildContent(context, state.users);
          } else {
            return const Center(child: Text('No data loaded'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<RestApiBloc>().add(FetchUsers());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<User> users) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ExpansionTile(
            leading: CircleAvatar(
              child: Text(user.name[0]),
            ),
            title: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(user.email),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.phone, 'Phone', user.phone),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.language, 'Website', user.website),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}