
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/config/graphql.dart';
import 'src/data/export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');
  runApp(MyApp(graphqlClient: ServicesGraphQl().init(),));
}

