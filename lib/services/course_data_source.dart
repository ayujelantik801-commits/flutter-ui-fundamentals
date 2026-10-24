// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 9 (P7): Kontrak sumber data. Repository hanya bergantung pada
// kelas abstrak ini, bukan pada REST atau Supabase secara langsung.
import '../models/course.dart';

abstract class CourseDataSource {
  Future<List<Course>> getCourses();
  Future<Course> createCourse(Course course);
  Future<void> updateCourse(int id, Course course);
  Future<void> deleteCourse(int id);
}