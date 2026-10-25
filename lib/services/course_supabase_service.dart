// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 12 (P7): Sumber data Supabase (SELECT).
// Memakai kontrak yang sama dengan CourseApiService (Tahap 9).
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  CourseSupabaseService([SupabaseClient? client])
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<Course>> getCourses() async {
    try {
      final rows = await _client.from('courses').select().order('id', ascending: true);
      return rows
          .map((row) => Course.fromJson(row))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Gagal membaca dari Supabase: ${e.message}');
    }
  }

  // Diisi di Tahap 13-15.
  @override
  Future<Course> createCourse(Course course) =>
      throw UnimplementedError('INSERT dikerjakan di Tahap 13');

  @override
  Future<void> updateCourse(int id, Course course) =>
      throw UnimplementedError('UPDATE dikerjakan di Tahap 14');

  @override
  Future<void> deleteCourse(int id) =>
      throw UnimplementedError('DELETE dikerjakan di Tahap 15');
}