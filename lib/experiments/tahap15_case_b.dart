// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 15 KASUS B: Provider dipanggil dari context yang berada DI ATAS
// ChangeNotifierProvider.
// Jalankan: flutter run -t lib/experiments/tahap15_case_b.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../repositories/course_repository.dart';
import '../services/course_service.dart';
import '../student_info.dart';

// true  = versi SALAH (akan muncul error ProviderNotFoundException)
// false = versi BENAR (setelah diperbaiki)
const bool useBrokenVersion = true;

void main() => runApp(const CaseBApp());

class CaseBApp extends StatelessWidget {
  const CaseBApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (useBrokenVersion) {
      // SALAH: `context` ini milik CaseBApp, berada DI ATAS
      // ChangeNotifierProvider yang dibuat di bawahnya, sehingga
      // CourseProvider belum bisa ditemukan dari sini.
      context.read<CourseProvider>();
    }

    return ChangeNotifierProvider(
      create: (_) => CourseProvider(CourseRepository(CourseService())),
      child: MaterialApp(
        title: 'Tahap 15 - Kasus B',
        theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
        home: const FixedPage(),
      ),
    );
  }
}

// BENAR: widget ini berada DI BAWAH ChangeNotifierProvider,
// jadi context-nya dapat menemukan CourseProvider.
class FixedPage extends StatelessWidget {
  const FixedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 15: Kasus B')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentName - $studentId',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Provider ditemukan. Jumlah favorit: ${provider.favorites.length}'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () =>
                  context.read<CourseProvider>().toggleFavorite('TEST01'),
              child: const Text('Toggle favorit uji'),
            ),
          ],
        ),
      ),
    );
  }
}