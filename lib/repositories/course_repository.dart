// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 10: Repository sebagai lapisan abstraksi antara Provider dan sumber data.
// Provider cukup memanggil getCourses() tanpa tahu data berasal dari mana.
// TAHAP 6 (P7): ditambah createCourse() untuk HTTP POST.
import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  final CourseApiService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.getCourses();
  }

  Future<Course> createCourse(Course course) {
    return service.createCourse(course);
  }
}