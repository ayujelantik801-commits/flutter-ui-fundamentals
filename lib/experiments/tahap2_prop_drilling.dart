// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 2: Eksperimen keterbatasan setState() untuk shared state.
// Jalankan: flutter run -t lib/experiments/tahap2_prop_drilling.dart
import 'package:flutter/material.dart';
import '../student_info.dart';

void main() => runApp(const Tahap2App());

class Tahap2App extends StatelessWidget {
  const Tahap2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 2 - Prop Drilling',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const ParentPage(),
    );
  }
}

const _courses = <Map<String, String>>[
  {'code': 'PM101', 'title': 'Pemrograman Mobile'},
  {'code': 'BD201', 'title': 'Basis Data'},
  {'code': 'JK301', 'title': 'Jaringan Komputer'},
];

// ---------------------------------------------------------------
// PARENT: pemilik state favorites (satu nilai pada parent)
// ---------------------------------------------------------------
class ParentPage extends StatefulWidget {
  const ParentPage({super.key});

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  final Set<String> favorites = {};

  // Callback yang akan diteruskan ke bawah lewat banyak constructor
  void toggleFavorite(String code) {
    setState(() {
      if (!favorites.remove(code)) favorites.add(code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 2: Prop Drilling')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentName - $studentId',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // CHILD 1: daftar course (menerima favorites + callback)
            Expanded(
              child: CourseListPanel(
                favorites: favorites,
                onToggleFavorite: toggleFavorite,
              ),
            ),
            const Divider(),
            // CHILD 2: ringkasan favorit (menerima favorites + callback)
            FavoriteSummaryPanel(
              favorites: favorites,
              onToggleFavorite: toggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// CHILD 1 (level 1): hanya meneruskan data ke level berikutnya
// ---------------------------------------------------------------
class CourseListPanel extends StatelessWidget {
  final Set<String> favorites;
  final void Function(String code) onToggleFavorite;

  const CourseListPanel({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final c in _courses)
          CourseTile(
            code: c['code']!,
            title: c['title']!,
            isFavorite: favorites.contains(c['code']), // diteruskan ke bawah
            onToggleFavorite: onToggleFavorite, // diteruskan ke bawah
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------
// CHILD 1 (level 2): juga hanya meneruskan callback
// ---------------------------------------------------------------
class CourseTile extends StatelessWidget {
  final String code;
  final String title;
  final bool isFavorite;
  final void Function(String code) onToggleFavorite;

  const CourseTile({
    super.key,
    required this.code,
    required this.title,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(code),
      trailing: FavoriteButton(
        isFavorite: isFavorite,
        onPressed: () => onToggleFavorite(code), // callback diteruskan lagi
      ),
    );
  }
}

// ---------------------------------------------------------------
// CHILD 1 (level 3): widget yang benar-benar memakai data & callback
// ---------------------------------------------------------------
class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
    );
  }
}

// ---------------------------------------------------------------
// CHILD 2: membaca favorites yang sama dan memakai callback yang sama
// ---------------------------------------------------------------
class FavoriteSummaryPanel extends StatelessWidget {
  final Set<String> favorites;
  final void Function(String code) onToggleFavorite;

  const FavoriteSummaryPanel({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total favorit: ${favorites.length}'),
        Wrap(
          spacing: 8,
          children: [
            for (final code in favorites)
              InputChip(
                label: Text(code),
                onDeleted: () => onToggleFavorite(code),
              ),
          ],
        ),
      ],
    );
  }
}