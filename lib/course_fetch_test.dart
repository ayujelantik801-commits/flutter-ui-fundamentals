import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'http://localhost:3000/courses';
//const String apiUrl = 'http://localhost:3000/coursess';

Future<List<dynamic>> fetchCourses() async {
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  }
  throw Exception('HTTP ${response.statusCode}');
}

Future<void> testFetchCourses() async {
  const owner = '2415051053 - I Gusti Ayu Putu Jelantik';
  try {
    final data = await fetchCourses();
    debugPrint('[$owner] Jumlah course: ${data.length}');
  } catch (e) {
    debugPrint('[$owner] ERROR: $e');
  }
}