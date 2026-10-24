// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/explorer_widgets.dart';
import 'course_actions.dart';

// ---------------------------------------------------------------
// COURSES: 1 kolom (compact), 2 kolom (medium), 3 kolom (expanded)
// TAHAP 5 (P7): state loading, error (ErrorView + Retry), empty, success
// TAHAP 7:  Consumer membungkus tiap card agar hanya card yang rebuild
// TAHAP 11: UI hanya membaca state async dari provider
// TAHAP 13: aksi toggle dan buka detail memakai course_actions.dart
// ---------------------------------------------------------------
class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    // 1) LOADING
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2) ERROR (pesan + tombol Retry)
    if (provider.error != null) {
      return ErrorView(
        message: 'Gagal memuat: ${provider.error}',
        onRetry: provider.loadCourses,
      );
    }

    // 3) EMPTY
    final courses = provider.courses;
    if (courses.isEmpty) {
      return const Center(child: Text('Data course belum tersedia'));
    }

    // 4) SUCCESS
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        Widget cardFor(Course course) {
          return Consumer<CourseProvider>(
            builder: (context, p, _) {
              debugPrint('REBUILD: CourseCard ${course.code} (Consumer)');
              return CourseCard(
                course: course.toJson(),
                isFavorite: p.isFavorite(course.code),
                onTap: () => openCourseDetail(context, course),
                onToggleFavorite: () =>
                    toggleFavoriteWithFeedback(context, course),
              );
            },
          );
        }

        // Compact: 1 kolom (list)
        if (width < 600) {
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: courses.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: cardFor(courses[index]),
            ),
          );
        }

        // Medium: 2 kolom, Expanded: 3 kolom
        final columns = width < 840 ? 2 : 3;
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 160,
          ),
          itemCount: courses.length,
          itemBuilder: (context, index) => cardFor(courses[index]),
        );
      },
    );
  }
}