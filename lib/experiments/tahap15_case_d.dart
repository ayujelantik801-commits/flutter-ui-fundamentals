// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 15 KASUS D: perubahan state setelah proses async pada widget lokal.
// Jalankan: flutter run -t lib/experiments/tahap15_case_d.dart
import 'package:flutter/material.dart';
import '../student_info.dart';

// false = TANPA pemeriksaan mounted (akan muncul error di Debug Console
//         jika halaman ditutup sebelum proses async selesai)
// true  = DENGAN pemeriksaan mounted (aman)
const bool checkMounted = false;

void main() => runApp(const CaseDApp());

class CaseDApp extends StatelessWidget {
  const CaseDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 15 - Kasus D',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 15: Kasus D')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentName - $studentId',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('checkMounted = $checkMounted'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SlowPage()),
              ),
              child: const Text('Buka halaman lambat'),
            ),
          ],
        ),
      ),
    );
  }
}

class SlowPage extends StatefulWidget {
  const SlowPage({super.key});

  @override
  State<SlowPage> createState() => _SlowPageState();
}

class _SlowPageState extends State<SlowPage> {
  String result = 'Belum dimuat';
  bool loading = false;

  Future<void> load() async {
    setState(() => loading = true);

    // Simulasi proses async 3 detik (misalnya request data)
    await Future.delayed(const Duration(seconds: 3));

    // PERBAIKAN: jika halaman sudah ditutup, jangan setState lagi
    if (checkMounted && !mounted) return;

    setState(() {
      result = 'Data selesai dimuat';
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Lambat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentName - $studentId',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Status: $result'),
            const SizedBox(height: 12),
            if (loading) const CircularProgressIndicator(),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: loading ? null : load,
              child: const Text('Muat data (3 detik)'),
            ),
            const SizedBox(height: 8),
            const Text('Tekan "Muat data", lalu segera tekan Back sebelum 3 detik.'),
          ],
        ),
      ),
    );
  }
}