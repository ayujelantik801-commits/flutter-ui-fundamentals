// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import 'identity.dart';

// Ubah ke false untuk melihat versi TANPA scroll (akan overflow)
const bool useScroll = true;

class Tahap6 extends StatelessWidget {
  const Tahap6({super.key});

  static const List<String> labels = [
    'Nama',
    'NIM',
    'Email',
    'Program Studi',
    'Kelas',
    'Alamat',
    'Nomor HP',
    'Hobi',
  ];

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '$studentId - $studentName',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Center(
          child: CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        ),
        const SizedBox(height: 16),
        ...labels.map(
          (label) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Simpan')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 6 - Scrollable Content')),
      body: useScroll
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: buildContent(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: buildContent(),
            ),
    );
  }
}