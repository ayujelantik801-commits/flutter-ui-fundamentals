// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import 'identity.dart';

/// Reusable widget #1: strip identitas mahasiswa
class IdentityBar extends StatelessWidget {
  const IdentityBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Text(
        '$studentId - $studentName',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Reusable widget #2: kartu course dengan tap dan tombol favorite
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

  Color statusColor(String status) {
    if (status == 'done') return Colors.green;
    if (status == 'active') return Colors.blue;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String;
    final color = statusColor(status);

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                course['title'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text('${course['code']} • ${course['credits']} SKS'),
              Text(
                course['lecturer'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Chip(
                    label: Text(status),
                    backgroundColor: color.withOpacity(0.15),
                    visualDensity: VisualDensity.compact,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: onToggleFavorite,
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