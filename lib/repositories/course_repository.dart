// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 9 (P7): Repository bergantung pada CourseDataSource (kontrak),
// bukan pada implementasi konkret. Sumber data bisa diganti tanpa
// mengubah repository, provider, maupun screen.
import '../models/course.dart';
import '../services/course_data_source.dart';

class CourseRepository {
  CourseRepository(this.dataSource);

  final CourseDataSource dataSource;

  Future<List<Course>> getCourses() => dataSource.getCourses();

  Future<Course> createCourse(Course course) =>
      dataSource.createCourse(course);

  Future<void> updateCourse(int id, Course course) =>
      dataSource.updateCourse(id, course);

  Future<void> deleteCourse(int id) => dataSource.deleteCourse(id);
}