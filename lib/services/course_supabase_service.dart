// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 12 (P7): Sumber data Supabase (SELECT).
// TAHAP 13 (P7): createCourse() INSERT.
// TAHAP 14 (P7): updateCourse() UPDATE berdasarkan id.
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
      final rows =
          await _client.from('courses').select().order('id', ascending: true);
      return rows.map((row) => Course.fromJson(row)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Gagal membaca dari Supabase: ${e.message}');
    }
  }

  @override
  Future<Course> createCourse(Course course) async {
    try {
      final row = await _client
          .from('courses')
          .insert(course.toJson())
          .select()
          .single();
      return Course.fromJson(row);
    } on PostgrestException catch (e) {
      // 23505 = unique_violation (code sudah ada)
      if (e.code == '23505') {
        throw Exception('Kode ${course.code} sudah ada di database');
      }
      throw Exception('Gagal menyimpan ke Supabase: ${e.message}');
    }
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    try {
      final updated = await _client
          .from('courses')
          .update(course.toJson())
          .eq('id', id)
          .select();
      // Jika RLS menolak atau id tidak ada, Supabase tidak melempar error
      // tetapi mengembalikan 0 baris. Anggap itu kegagalan.
      if (updated.isEmpty) {
        throw Exception('Tidak ada data yang diperbarui (id $id)');
      }
    } on PostgrestException catch (e) {
      throw Exception('Gagal memperbarui di Supabase: ${e.message}');
    }
  }

  // Diisi di Tahap 15.
  @override
  Future<void> deleteCourse(int id) =>
      throw UnimplementedError('DELETE dikerjakan di Tahap 15');
}