import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_api_service.dart';
import 'services/course_data_source.dart';

const String studentName = 'I Gusti Ayu Putu Jelantik';
const String studentId = '2415051053';

// Base URL tanpa /courses (path ditambahkan di CourseApiService).
const String apiBaseUrl = 'http://localhost:3000';

void main() {
  // Hanya baris ini yang berubah saat sumber data diganti
  // (nanti: CourseSupabaseService()).
  final CourseDataSource dataSource = CourseApiService(apiBaseUrl);
  final repository = CourseRepository(dataSource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
      child: const CourseExplorerApp(),
    ),
  );
}