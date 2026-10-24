// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../student_info.dart';

// ---------------------------------------------------------------
// HOME
// TAHAP 7: context.watch() -> membaca state DAN ikut rebuild saat berubah
// ---------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteCount = context.watch<CourseProvider>().favorites.length;
    debugPrint('REBUILD: HomeScreen (watch)');

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school, size: 64),
            const SizedBox(height: 12),
            const Text(
              'Selamat datang di Course Explorer',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('$studentId - $studentName'),
            const SizedBox(height: 16),
            Text('Course favorit: $favoriteCount'),
          ],
        ),
      ),
    );
  }
}