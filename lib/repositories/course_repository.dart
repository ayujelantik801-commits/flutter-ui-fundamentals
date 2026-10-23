// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 10: Repository sebagai lapisan abstraksi antara Provider dan sumber data.
// Provider cukup memanggil getCourses() tanpa tahu data berasal dari mana.
import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}