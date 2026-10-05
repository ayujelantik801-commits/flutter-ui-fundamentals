import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Map<String, dynamic>>> loadCourses() async {
  final jsonString =
      await rootBundle.loadString('assets/data/student_data.json');
  final data = jsonDecode(jsonString) as Map<String, dynamic>;
  return (data['courses'] as List<dynamic>).cast<Map<String, dynamic>>();
}