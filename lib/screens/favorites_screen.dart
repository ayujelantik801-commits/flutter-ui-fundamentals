// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 13: FavoritesScreen hanya menampilkan course favorit.
// Datanya dari CourseProvider yang sama dengan list dan detail.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/explorer_widgets.dart';
import 'course_actions.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    debugPrint('REBUILD: FavoritesScreen (watch)');

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final favorites = provider.courses
        .where((course) => provider.isFavorite(course.code))
        .toList();

    if (favorites.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_border, size: 64),
              SizedBox(height: 12),
              Text(
                'Belum ada course favorit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Tekan ikon hati di tab Courses untuk menambahkan.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final course = favorites[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CourseCard(
                course: course.toJson(),
                isFavorite: true,
                onTap: () => openCourseDetail(context, course),
                onToggleFavorite: () =>
                    toggleFavoriteWithFeedback(context, course),
              ),
            );
          },
        ),
      ),
    );
  }
}