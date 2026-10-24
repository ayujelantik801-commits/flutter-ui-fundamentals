import 'package:flutter/material.dart';
import 'package:lat2ayujelantik/models/course.dart';
import 'course_fetch_test.dart';

const String studentName = 'I Gusti Ayu Putu Jelantik';
const String studentId = '2415051053';

Future<List<Course>> fetchCourseModels() async {
  final data = await fetchCourses();
  return data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
}

void main() => runApp(const MaterialApp(home: CourseFetchDemo()));

class CourseFetchDemo extends StatefulWidget {
  const CourseFetchDemo({super.key});

  @override
  State<CourseFetchDemo> createState() => _CourseFetchDemoState();
}

class _CourseFetchDemoState extends State<CourseFetchDemo> {
  late final Future<List<Course>> _future = fetchCourseModels();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$studentId - $studentName')),
      body: FutureBuilder<List<Course>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final courses = snapshot.data!;
          return ListView(
            children: [
              for (final c in courses)
                ListTile(
                  title: Text(c.title),
                  subtitle: Text('${c.code} • ${c.credits} SKS'),
                  trailing: Text(c.status),
                ),
            ],
          );
        },
      ),
    );
  }
}
