// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 4: ValueNotifier dan ValueListenableBuilder.
// Jalankan: flutter run -t lib/experiments/tahap4_value_notifier.dart
import 'package:flutter/material.dart';
import '../student_info.dart';

void main() => runApp(const Tahap4App());

class Tahap4App extends StatelessWidget {
  const Tahap4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 4 - ValueNotifier',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const ValueNotifierPage(),
    );
  }
}

class ValueNotifierPage extends StatefulWidget {
  const ValueNotifierPage({super.key});

  @override
  State<ValueNotifierPage> createState() => _ValueNotifierPageState();
}

class _ValueNotifierPageState extends State<ValueNotifierPage> {
  // Pola A: nilai biasa + setState()
  int favoriteCountSetState = 0;

  // Pola B: ValueNotifier (nilai yang bisa "didengarkan")
  final ValueNotifier<int> favoriteCountNotifier = ValueNotifier<int>(0);

  // Hanya untuk demo: menghitung berapa kali build() parent dipanggil.
  int parentBuildCount = 0;

  @override
  void dispose() {
    favoriteCountNotifier.dispose(); // wajib dibersihkan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    parentBuildCount++;

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 4: ValueNotifier')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentName - $studentId',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              'Parent di-build: $parentBuildCount kali',
              style: const TextStyle(color: Colors.deepPurple),
            ),
            const Divider(height: 32),

            // ---------- A. setState ----------
            const Text(
              'A. setState()',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Jumlah favorite: $favoriteCountSetState',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () => setState(() => favoriteCountSetState++),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    if (favoriteCountSetState > 0) {
                      setState(() => favoriteCountSetState--);
                    }
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text('Kurangi'),
                ),
              ],
            ),
            const Text('Seluruh parent ikut di-build ulang.'),

            const Divider(height: 32),

            // ---------- B. ValueNotifier ----------
            const Text(
              'B. ValueNotifier + ValueListenableBuilder',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ValueListenableBuilder<int>(
              valueListenable: favoriteCountNotifier,
              builder: (context, value, child) {
                return Text(
                  'Jumlah favorite: $value',
                  style: const TextStyle(fontSize: 20),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () => favoriteCountNotifier.value++,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    if (favoriteCountNotifier.value > 0) {
                      favoriteCountNotifier.value--;
                    }
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text('Kurangi'),
                ),
              ],
            ),
            const Text('Hanya ValueListenableBuilder yang di-build ulang.'),
          ],
        ),
      ),
    );
  }
}