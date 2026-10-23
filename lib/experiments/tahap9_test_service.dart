// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 9: Uji CourseService secara terpisah dari app utama.
// Jalankan: flutter run -t lib/experiments/tahap9_test_service.dart
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../student_info.dart';

void main() => runApp(const Tahap9App());

class Tahap9App extends StatelessWidget {
  const Tahap9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 9 - CourseService',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const ServiceTestPage(),
    );
  }
}

class ServiceTestPage extends StatefulWidget {
  const ServiceTestPage({super.key});

  @override
  State<ServiceTestPage> createState() => _ServiceTestPageState();
}

class _ServiceTestPageState extends State<ServiceTestPage> {
  late final Future<List<Course>> future;

  @override
  void initState() {
    super.initState();
    future = CourseService().loadCourses().then((courses) {
      debugPrint('SERVICE: berhasil memuat ${courses.length} course');
      for (final c in courses) {
        debugPrint('SERVICE: ${c.code} | ${c.title} | ${c.credits} SKS');
      }
      return courses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 9: Uji CourseService')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentName - $studentId',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Course>>(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Gagal memuat: ${snapshot.error}');
                  }
                  final courses = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tipe data: List<Course>, jumlah: ${courses.length}'),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView(
                          children: [
                            for (final c in courses)
                              ListTile(
                                title: Text(c.title),
                                subtitle: Text(
                                  '${c.code} • ${c.credits} SKS • ${c.status}',
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}