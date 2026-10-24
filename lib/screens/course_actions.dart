// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 13: aksi yang dipakai bersama oleh beberapa screen
// (list, favorites) agar tidak duplikat. Semua aksi lewat CourseProvider.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import 'course_detail_screen.dart';

void toggleFavoriteWithFeedback(BuildContext context, Course course) {
  final provider = context.read<CourseProvider>(); // read: hanya aksi
  final wasFavorite = provider.isFavorite(course.code);
  provider.toggleFavorite(course.code);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          wasFavorite
              ? '${course.title} dihapus dari favorit'
              : '${course.title} ditambahkan ke favorit',
        ),
      ),
    );
}

void openCourseDetail(BuildContext context, Course course) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
  );
}