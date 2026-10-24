import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_api_service.dart';

const String studentName = 'I Gusti Ayu Putu Jelantik';
const String studentId = '2415051053';

// Base URL tanpa /courses (path ditambahkan di CourseApiService).
const String apiBaseUrl = 'http://localhost:3000';

void main() {
  runApp(
    ChangeNotifierProvider(
      // service -> repository -> provider, lalu muat data
      create: (_) => CourseProvider(
        CourseRepository(CourseApiService(apiBaseUrl)),
      )..loadCourses(),
      child: const CourseExplorerApp(),
    ),
  );
}