import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'config/supabase_config.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
// ignore: unused_import
import 'services/course_api_service.dart'; // tetap ada untuk berpindah ke REST
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart';

const String studentName = 'I Gusti Ayu Putu Jelantik';
const String studentId = '2415051053';

// Dipakai hanya jika berpindah ke REST (json-server).
const String apiBaseUrl = 'http://localhost:3000';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Data source aktif: Supabase.
  // Untuk REST: CourseApiService(apiBaseUrl)
  final CourseDataSource dataSource = CourseSupabaseService();
  final repository = CourseRepository(dataSource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
      child: const CourseExplorerApp(),
    ),
  );
}