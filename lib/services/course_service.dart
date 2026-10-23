// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 9: Service / data source.
// Bertanggung jawab pada detail teknis sumber data (JSON asset).
// Nanti dapat diganti API tanpa mengubah screen secara langsung.
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/course.dart';

class CourseService {
  Future<List<Course>> loadCourses() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );
    final data = jsonDecode(jsonString);

    // Mendukung {"courses": [...]} maupun langsung [...]
    final list = (data is Map<String, dynamic> ? data['courses'] : data)
        as List<dynamic>;

    return list
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}