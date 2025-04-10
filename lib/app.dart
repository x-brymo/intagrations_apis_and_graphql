import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'src/domain/manager/export.dart';
import 'src/view/export.dart';

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> graphqlClient;
  
  const MyApp({super.key, required this.graphqlClient});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HiveBloc>(
          create: (context) => HiveBloc(),
        ),
        BlocProvider<SqfliteBloc>(
          create: (context) => SqfliteBloc(),
        ),
        BlocProvider<RestApiBloc>(
          create: (context) => RestApiBloc(),
        ),
        BlocProvider<GraphQLBloc>(
          create: (context) => GraphQLBloc(client: graphqlClient.value),
        ),
      ],
      child: GraphQLProvider(
        client: graphqlClient,
        child: MaterialApp(
          title: 'Flutter Database Integrations',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/hive': (context) => const HiveScreen(),
            '/sqflite': (context) => const SqfliteScreen(),
            '/rest_api': (context) => const RestApiScreen(),
            '/graphql': (context) => const GraphQLScreen(),
          },
        ),
      ),
    );
  }
}