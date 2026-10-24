// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_explorer.dart';
import 'course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // TAHAP 11: rangkai service -> repository -> provider, lalu muat data
      create: (_) => CourseProvider(
        CourseRepository(CourseService()),
      )..loadCourses(),
      child: const CourseExplorerApp(),
    ),
  );
}