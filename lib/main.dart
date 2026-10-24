import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_service.dart';

const String studentName = 'I Gusti Ayu Putu Jelantik';
const String studentId = '245051053';

void main() {
  runApp(
    ChangeNotifierProvider(
      // service -> repository -> provider, lalu muat data
      create: (_) => CourseProvider(
        CourseRepository(CourseService()),
      )..loadCourses(),
      child: const CourseExplorerApp(),
    ),
  );
}