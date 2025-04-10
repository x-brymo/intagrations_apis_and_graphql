// Readme.md
/*
# Flutter Database Integration App

A comprehensive Flutter application demonstrating various database integrations and API connections using the BLoC pattern.

## Features

### Local Storage
- **Hive**: A lightweight and fast NoSQL database for Flutter
- **SQLite (sqflite)**: A local SQL database implementation

### API Connections
- **REST API**: Integration with JSONPlaceholder API
- **GraphQL**: Integration with GraphQLZero API

## Getting Started

1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter pub run build_runner build` to generate Hive adapters
4. Run the app with `flutter run`

## Dependencies

- flutter_bloc: For state management
- hive & hive_flutter: For NoSQL database
- sqflite: For SQLite database
- http: For REST API calls
- graphql_flutter: For GraphQL API integration
- path_provider & path: For file system access
- uuid: For generating unique IDs

## Project Structure

- **models/**: Data models for each type of storage
- **bloc/**: BLoC pattern implementation for each storage type
- **screens/**: UI screens for demonstrating each integration

## Learning Resources

This app demonstrates:
- BLoC pattern for state management
- CRUD operations with Hive
- CRUD operations with SQLite
- REST API integration
- GraphQL API integration
*/