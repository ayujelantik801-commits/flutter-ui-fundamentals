// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 10: Uji CourseRepository dan buktikan sumber data bisa diganti.
// Jalankan: flutter run -t lib/experiments/tahap10_test_repository.dart
// Catatan: tombol "REST API" membutuhkan json-server yang sedang menyala.
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';
import '../services/course_api_service.dart';
import '../student_info.dart';

const String apiBaseUrl = 'http://localhost:3000';

void main() => runApp(const Tahap10App());

// Simulasi sumber data lain. Repository TIDAK berubah.
class FakeCourseService extends CourseApiService {
  FakeCourseService() : super(apiBaseUrl);

  @override
  Future<List<Course>> getCourses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      Course(
        code: 'API01',
        title: 'Course dari API (simulasi)',
        credits: 3,
        status: 'active',
        lecturer: 'Dosen API',
      ),
    ];
  }
}

class Tahap10App extends StatelessWidget {
  const Tahap10App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 10 - Repository',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const RepositoryTestPage(),
    );
  }
}

class RepositoryTestPage extends StatefulWidget {
  const RepositoryTestPage({super.key});

  @override
  State<RepositoryTestPage> createState() => _RepositoryTestPageState();
}

class _RepositoryTestPageState extends State<RepositoryTestPage> {
  late CourseRepository repository;
  late Future<List<Course>> future;
  String sourceLabel = 'REST API (CourseApiService)';

  @override
  void initState() {
    super.initState();
    useService(
      CourseApiService(apiBaseUrl),
      'REST API (CourseApiService)',
    );
  }

  void useService(CourseApiService service, String label) {
    repository = CourseRepository(service);
    future = repository.getCourses().then((courses) {
      debugPrint('REPOSITORY [$label]: ${courses.length} course');
      return courses;
    });
    sourceLabel = label;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 10: Uji Repository')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentName - $studentId',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Sumber data: $sourceLabel'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: () => setState(
                    () => useService(
                      CourseApiService(apiBaseUrl),
                      'REST API (CourseApiService)',
                    ),
                  ),
                  child: const Text('REST API'),
                ),
                OutlinedButton(
                  onPressed: () => setState(
                    () => useService(
                      FakeCourseService(),
                      'API simulasi (FakeCourseService)',
                    ),
                  ),
                  child: const Text('API simulasi'),
                ),
              ],
            ),
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
                  return ListView(
                    children: [
                      for (final c in courses)
                        ListTile(
                          title: Text(c.title),
                          subtitle: Text(
                            '${c.code} • ${c.credits} SKS • ${c.status}',
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