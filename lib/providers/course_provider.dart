// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 5 + 11: ChangeNotifier untuk shared state course
// (favorites) dan async state (courses, isLoading, error).
import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  // TAHAP 11: repository sebagai dependency (bukan rootBundle langsung)
  final CourseRepository repository;

  CourseProvider(this.repository);

  // ---- Async state ----
  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  // ---- Shared state (Tahap 5) ----
  final Set<String> favorites = {};

  bool isFavorite(String code) => favorites.contains(code);

  void toggleFavorite(String code) {
    if (favorites.contains(code)) {
      favorites.remove(code);
    } else {
      favorites.add(code);
    }
    notifyListeners();
  }

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Aktifkan baris di bawah SEMENTARA untuk memotret tampilan loading:
      // await Future.delayed(const Duration(seconds: 2));
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}