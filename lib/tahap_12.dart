// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import 'course_data.dart';
import 'identity.dart';

class CourseTile extends StatefulWidget {
  final Map<String, dynamic> course;
  const CourseTile({super.key, required this.course});

  @override
  State<CourseTile> createState() => _CourseTileState();
}

class _CourseTileState extends State<CourseTile> {
  bool isFavorite = false;

  void showInfo() {
    final course = widget.course;
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course['title'] as String,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Kode: ${course['code']} • ${course['credits']} SKS'),
            Text('Dosen: ${course['lecturer']}'),
            Text('Status: ${course['status']}'),
            const SizedBox(height: 12),
            const Text('$studentId - $studentName'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tap: ${course['title']}')),
          );
        },
        onLongPress: showInfo,
        child: ListTile(
          title: Text(course['title'] as String),
          subtitle: Text('${course['code']} • ${course['credits']} SKS'),
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              setState(() => isFavorite = !isFavorite);
            },
          ),
        ),
      ),
    );
  }
}

class Tahap12 extends StatefulWidget {
  const Tahap12({super.key});

  @override
  State<Tahap12> createState() => _Tahap12State();
}

class _Tahap12State extends State<Tahap12> {
  late Future<List<Map<String, dynamic>>> coursesFuture;
  int doubleTapCount = 0;

  @override
  void initState() {
    super.initState();
    coursesFuture = loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 12 - Interaksi')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              '$studentId - $studentName',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // GestureDetector: mendeteksi gesture, TANPA efek ripple
          GestureDetector(
            onDoubleTap: () => setState(() => doubleTapCount++),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              color: Colors.amber.shade100,
              child: Text('GestureDetector: double tap aku ($doubleTapCount)'),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: coursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Gagal memuat: ${snapshot.error}'));
                }
                final courses = snapshot.data!;
                return ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) =>
                      CourseTile(course: courses[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}