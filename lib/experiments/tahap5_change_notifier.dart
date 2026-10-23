// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 5: Menguji ChangeNotifier dan notifyListeners().
// Jalankan: flutter run -t lib/experiments/tahap5_change_notifier.dart
import 'package:flutter/material.dart';
import '../course_provider.dart';
import '../student_info.dart';

void main() => runApp(const Tahap5App());

class Tahap5App extends StatelessWidget {
  const Tahap5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 5 - ChangeNotifier',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const ChangeNotifierPage(),
    );
  }
}

const _courses = <Map<String, String>>[
  {'code': 'PM101', 'title': 'Pemrograman Mobile'},
  {'code': 'BD201', 'title': 'Basis Data'},
  {'code': 'JK301', 'title': 'Jaringan Komputer'},
];

class ChangeNotifierPage extends StatefulWidget {
  const ChangeNotifierPage({super.key});

  @override
  State<ChangeNotifierPage> createState() => _ChangeNotifierPageState();
}

class _ChangeNotifierPageState extends State<ChangeNotifierPage> {
  // Object state dibuat sekali dan hidup selama halaman ada.
  // (Di Tahap 6 object ini akan disediakan oleh Provider.)
  final CourseProvider provider = CourseProvider();

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 5: ChangeNotifier')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentName - $studentId',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // ListenableBuilder "mendengarkan" provider. Setiap
            // notifyListeners() memicu builder ini dijalankan ulang.
            Expanded(
              child: ListenableBuilder(
                listenable: provider,
                builder: (context, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total favorit: ${provider.favorites.length}'),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView(
                          children: [
                            for (final c in _courses)
                              ListTile(
                                title: Text(c['title']!),
                                subtitle: Text(c['code']!),
                                trailing: IconButton(
                                  onPressed: () =>
                                      provider.toggleFavorite(c['code']!),
                                  icon: Icon(
                                    provider.isFavorite(c['code']!)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: provider.isFavorite(c['code']!)
                                        ? Colors.red
                                        : null,
                                  ),
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