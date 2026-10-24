// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// WIDGET REUSABLE untuk Course Explorer: IdentityBar dan CourseCard.
// Kedua widget stateless: data turun lewat constructor, aksi naik lewat callback.
import 'package:flutter/material.dart';
import '../student_info.dart';
import '../models/course.dart';

// ---------------------------------------------------------------
// IdentityBar: bar identitas (NIM - Nama) di bawah AppBar
// ---------------------------------------------------------------
class IdentityBar extends StatelessWidget {
  const IdentityBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      color: colors.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        '$studentId - $studentName',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: colors.onPrimaryContainer,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// CourseCard: kartu satu course (judul, kode, SKS, dosen, status, favorit)
// ---------------------------------------------------------------
class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const CourseCard({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'done':
        return Colors.green.shade100;
      case 'active':
        return Colors.blue.shade100;
      default:
        return Colors.amber.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = course['status'].toString();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course['title'].toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text('${course['code']} • ${course['credits']} SKS'),
              Text(
                (course['lecturer'] ?? Course.defaultLecturer).toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(status),
                      border: Border.all(color: Colors.black45),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(status),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: onToggleFavorite,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}