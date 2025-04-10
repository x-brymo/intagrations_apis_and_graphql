// screens/home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Integrations App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Flutter Database & API Integrations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildIntegrationCard(
              context,
              title: 'Hive',
              subtitle: 'Fast NoSQL database for Flutter',
              icon: Icons.storage,
              color: Colors.amber,
              route: '/hive',
            ),
            _buildIntegrationCard(
              context,
              title: 'SQLite (sqflite)',
              subtitle: 'Local SQL database for Flutter',
              icon: Icons.data_usage,
              color: Colors.green,
              route: '/sqflite',
            ),
            _buildIntegrationCard(
              context,
              title: 'REST API',
              subtitle: 'JSON Placeholder API integration',
              icon: Icons.cloud,
              color: Colors.blue,
              route: '/rest_api',
            ),
            _buildIntegrationCard(
              context,
              title: 'GraphQL',
              subtitle: 'GraphQL API integration',
              icon: Icons.device_hub,
              color: Colors.purple,
              route: '/graphql',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}