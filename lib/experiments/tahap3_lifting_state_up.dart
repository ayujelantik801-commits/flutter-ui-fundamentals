// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 3: Lifting state up dan single source of truth.
// Jalankan: flutter run -t lib/experiments/tahap3_lifting_state_up.dart
import 'package:flutter/material.dart';
import '../student_info.dart';

void main() => runApp(const Tahap3App());

class Tahap3App extends StatelessWidget {
  const Tahap3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 3 - Lifting State Up',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const LiftingStatePage(),
    );
  }
}

// ---------------------------------------------------------------
// PARENT: pemilik tunggal state favorite (single source of truth)
// ---------------------------------------------------------------
class LiftingStatePage extends StatefulWidget {
  const LiftingStatePage({super.key});

  @override
  State<LiftingStatePage> createState() => _LiftingStatePageState();
}

class _LiftingStatePageState extends State<LiftingStatePage> {
  bool favorite = false; // SATU-SATUNYA sumber kebenaran

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 3: Lifting State Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentName - $studentId',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // ---------- A. CARA SALAH ----------
            const Text(
              'A. SALAH: state ganda (tidak sinkron)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text('Tekan hati di kartu, lalu lihat badge: nilainya beda.'),
            const SizedBox(height: 8),
            const BadCourseCard(),
            const BadFavoriteBadge(),

            const Divider(height: 32),

            // ---------- B. CARA BENAR ----------
            const Text(
              'B. BENAR: single source of truth di parent',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text('Kartu dan badge selalu menampilkan nilai yang sama.'),
            const SizedBox(height: 8),
            CourseCard(
              isFavorite: favorite, // data turun lewat constructor
              onFavoriteChanged: () {
                // aksi naik lewat callback
                setState(() {
                  favorite = !favorite;
                });
              },
            ),
            FavoriteBadge(isFavorite: favorite),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// BENAR: child stateless, hanya menerima data dan mengirim aksi
// ---------------------------------------------------------------
class CourseCard extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const CourseCard({
    super.key,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Pemrograman Mobile'),
        subtitle: const Text('PM101'),
        trailing: IconButton(
          onPressed: onFavoriteChanged,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
        ),
      ),
    );
  }
}

class FavoriteBadge extends StatelessWidget {
  final bool isFavorite;
  const FavoriteBadge({super.key, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      label: Text(isFavorite ? 'Status: FAVORIT' : 'Status: bukan favorit'),
    );
  }
}

// ---------------------------------------------------------------
// SALAH: setiap widget menyimpan salinan state sendiri
// ---------------------------------------------------------------
class BadCourseCard extends StatefulWidget {
  const BadCourseCard({super.key});

  @override
  State<BadCourseCard> createState() => _BadCourseCardState();
}

class _BadCourseCardState extends State<BadCourseCard> {
  bool isFavorite = false; // salinan #1

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Pemrograman Mobile'),
        subtitle: const Text('PM101'),
        trailing: IconButton(
          onPressed: () => setState(() => isFavorite = !isFavorite),
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
        ),
      ),
    );
  }
}

class BadFavoriteBadge extends StatefulWidget {
  const BadFavoriteBadge({super.key});

  @override
  State<BadFavoriteBadge> createState() => _BadFavoriteBadgeState();
}

class _BadFavoriteBadgeState extends State<BadFavoriteBadge> {
  bool isFavorite = false; // salinan #2 (tidak tahu salinan #1)

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      label: Text(isFavorite ? 'Status: FAVORIT' : 'Status: bukan favorit'),
      onDeleted: () => setState(() => isFavorite = !isFavorite),
      deleteIcon: const Icon(Icons.sync),
    );
  }
}