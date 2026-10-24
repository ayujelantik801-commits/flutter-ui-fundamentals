import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'config/supabase_config.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_api_service.dart';
import 'services/course_data_source.dart';

const String studentName = 'I Gusti Ayu Putu Jelantik';
const String studentId = '2415051053';

// Base URL tanpa /courses (path ditambahkan di CourseApiService).
const String apiBaseUrl = 'http://localhost:3000';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TAHAP 10 (P7): inisialisasi Supabase sebelum runApp().
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  debugPrint('[$studentId - $studentName] Supabase berhasil diinisialisasi');

  // Sumber data aktif masih REST (Supabase dipakai mulai Tahap 12).
  // Hanya baris ini yang berubah saat berpindah sumber data.
  final CourseDataSource dataSource = CourseApiService(apiBaseUrl);
  final repository = CourseRepository(dataSource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
      child: const CourseExplorerApp(),
    ),
  );
}