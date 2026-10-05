// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import 'identity.dart';

class Tahap3 extends StatelessWidget {
  const Tahap3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 3 - LayoutBuilder')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return const CompactLayout();
          } else if (constraints.maxWidth < 840) {
            return const MediumLayout();
          } else {
            return const ExpandedLayout();
          }
        },
      ),
    );
  }
}

class InfoPanel extends StatelessWidget {
  final String kategori;
  final Color color;
  const InfoPanel({super.key, required this.kategori, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Layout: $kategori',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(studentName),
          const Text(studentId),
        ],
      ),
    );
  }
}

// Compact: 1 panel, biru
class CompactLayout extends StatelessWidget {
  const CompactLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: InfoPanel(kategori: 'Compact', color: Colors.blue.shade100),
        ),
      ],
    );
  }
}

// Medium: 2 panel berdampingan, oranye
class MediumLayout extends StatelessWidget {
  const MediumLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InfoPanel(kategori: 'Medium', color: Colors.orange.shade100),
        ),
        Expanded(
          child: InfoPanel(kategori: 'Medium', color: Colors.orange.shade200),
        ),
      ],
    );
  }
}

// Expanded: 3 panel berdampingan, hijau
class ExpandedLayout extends StatelessWidget {
  const ExpandedLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InfoPanel(kategori: 'Expanded', color: Colors.green.shade100),
        ),
        Expanded(
          child: InfoPanel(kategori: 'Expanded', color: Colors.green.shade200),
        ),
        Expanded(
          child: InfoPanel(kategori: 'Expanded', color: Colors.green.shade300),
        ),
      ],
    );
  }
}