// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/explorer_widgets.dart';
import 'course_actions.dart';

// ---------------------------------------------------------------
// DETAIL
// TAHAP 1:  StatefulWidget untuk LOCAL STATE (showLecturer)
// TAHAP 13: status favorit dibaca dari CourseProvider (shared state),
//           bukan lagi dikirim lewat constructor / Navigator.pop.
// ---------------------------------------------------------------
class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  bool showLecturer = true; // LOCAL STATE (setState)

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    // watch: halaman ini harus ikut berubah saat favorit di-toggle
    final isFavorite = context.watch<CourseProvider>().isFavorite(course.code);
    debugPrint('REBUILD: Detail ${course.code} (watch)');

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Course')),
      body: Column(
        children: [
          const IdentityBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                        size: 32,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Kode: ${course.code}'),
                  Text('SKS: ${course.credits}'),
                  Text('Status: ${course.status}'),
                  Text('Favorit: ${isFavorite ? 'Ya' : 'Belum'}'),
                  if (showLecturer) Text('Dosen: ${course.lecturer}'),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => showLecturer = !showLecturer);
                    },
                    icon: Icon(
                      showLecturer ? Icons.visibility_off : Icons.visibility,
                    ),
                    label: Text(
                      showLecturer
                          ? 'Sembunyikan info dosen'
                          : 'Tampilkan info dosen',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    // read lewat helper: langsung ubah state di provider
                    onPressed: () =>
                        toggleFavoriteWithFeedback(context, course),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    label: Text(
                      isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}