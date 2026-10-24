// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// WIDGET: bar identitas (NIM - Nama) yang tampil di bawah AppBar.
import 'package:flutter/material.dart';
import '../student_info.dart';

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