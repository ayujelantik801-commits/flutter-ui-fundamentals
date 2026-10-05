// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'identity.dart';

Future<List<Map<String, dynamic>>> loadCourses() async {
  final jsonString =
      await rootBundle.loadString('assets/data/student_data.json');
  final data = jsonDecode(jsonString) as Map<String, dynamic>;
  return (data['courses'] as List<dynamic>).cast<Map<String, dynamic>>();
}

int columnsFor(double width) {
  if (width < 600) return 1;
  if (width < 840) return 2;
  return 3;
}

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String;
    final color = status == 'done'
        ? Colors.green
        : status == 'active'
            ? Colors.blue
            : Colors.orange;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              course['title'] as String,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text('${course['code']} • ${course['credits']} SKS'),
            Text(
              course['lecturer'] as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Chip(
              label: Text(status),
              backgroundColor: color.withOpacity(0.15),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}

class Tahap5 extends StatefulWidget {
  const Tahap5({super.key});

  @override
  State<Tahap5> createState() => _Tahap5State();
}

class _Tahap5State extends State<Tahap5> {
  late Future<List<Map<String, dynamic>>> coursesFuture;

  @override
  void initState() {
    super.initState();
    coursesFuture = loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 5 - GridView Responsif')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '$studentId - $studentName',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
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
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = columnsFor(constraints.maxWidth);
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 170,
                      ),
                      itemCount: courses.length,
                      itemBuilder: (context, index) =>
                          CourseCard(course: courses[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}