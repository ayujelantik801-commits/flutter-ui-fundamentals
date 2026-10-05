// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import 'identity.dart';

class Tahap4 extends StatelessWidget {
  const Tahap4({super.key});

  static const List<String> skills = [
    'Flutter',
    'Dart',
    'Git',
    'GitHub',
    'JSON',
    'Responsive UI',
    'Navigation',
    'Widget',
  ];

  Widget buildBox(String label, Color color) {
    return Container(
      height: 80,
      color: color,
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 4 - Expanded, Flexible, Wrap')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentId - $studentName'),
            const SizedBox(height: 16),

            const Text('1. Row + Expanded (flex 2 : 1)'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(flex: 2, child: buildBox('A (flex 2)', Colors.blue.shade100)),
                const SizedBox(width: 8),
                Expanded(child: buildBox('B (flex 1)', Colors.orange.shade100)),
              ],
            ),
            const SizedBox(height: 24),

            const Text('2. Wrap (chip pindah baris otomatis)'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((e) => Chip(label: Text(e))).toList(),
            ),
            const SizedBox(height: 24),

            const Text('3. Row biasa (pembanding, akan overflow)'),
            const SizedBox(height: 8),
            Row(
              children: skills
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(label: Text(e)),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}