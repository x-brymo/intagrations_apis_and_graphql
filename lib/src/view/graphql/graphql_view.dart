// screens/graphql_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intagrations_apis_and_graphql/src/data/models/post.dart';
import '../../data/datasource/check_network.dart';
import '../../domain/manager/export.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class GraphQLScreen extends StatefulWidget {
  const GraphQLScreen({super.key});

  @override
  _GraphQLScreenState createState() => _GraphQLScreenState();
}

class _GraphQLScreenState extends State<GraphQLScreen> {

  final CheckNetwork _checkNetwork = CheckNetwork(Connectivity());
  @override
  void initState() {
    super.initState();
    _fetchData(context);
  }
  Future<void> _fetchData(BuildContext context) async {
    bool isConnected = await _checkNetwork.isConnected();
    if (!isConnected) {
      _showRetryDialog(context);
      return;
    }
     context.read<GraphQLBloc>().add(FetchPosts());
    
  }

  void _showRetryDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('No Internet Connection'),
        content: Text('Please check your connection and try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _fetchData(context);
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GraphQL API Integration'),
      ),
      body: BlocConsumer<GraphQLBloc, GraphQLState>(
        listener: (context, state) {
          if (state is GraphQLErrors) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is GraphQLLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GraphQLLoaded) {
            return _buildContent(context, state.posts);
          } else {
            return const Center(child: Text('No data loaded'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<GraphQLBloc>().add(FetchPosts());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Post> posts) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ExpansionTile(
            title: Text(
              post.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              post.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(post.body),
              ),
            ],
          ),
        );
      },
    );
  }
}