import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'I Gusti Ayu Putu Jelantik';
const String studentId = '2415051053';

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

void main() {
  runApp(const MyApp());
}

// Tahap 8: Reusable widget
Widget buildStatCard(String value, String label, IconData icon) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(label),
          ],
        ),
      ),
    ),
  );
}

// Tahap 9: StatefulWidget dengan TextField dan setState()
class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  final TextEditingController controller = TextEditingController();
  String message = 'Belum ada pesan';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$studentId - $studentName',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Tulis pesan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  message = controller.text.trim().isEmpty
                      ? 'Input masih kosong'
                      : controller.text.trim();
                });
              },
              child: const Text('Tampilkan'),
            ),
            const SizedBox(height: 12),
            Text(message),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}

// Tahap 13-14: StatefulWidget dengan late Future + FutureBuilder
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Dashboard')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;
          final int completedCount = courses
              .where((c) => (c as Map<String, dynamic>)['status'] == 'done')
              .length;
          final int totalCredits = courses.fold<int>(
            0,
            (sum, c) => sum + ((c as Map<String, dynamic>)['credits'] as int),
          );

          return Column(
            children: [
              // Bagian atas: profil, statistik, greeting card (bisa discroll)
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 46,
                                  backgroundImage: const AssetImage(
                                    'assets/images/XTML7802.JPG',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  student['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(student['nim'] as String),
                                const SizedBox(height: 2),
                                Text(
                                  'Semester ${student['semester']}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            buildStatCard(
                              '${courses.length}',
                              'Mata Kuliah',
                              Icons.menu_book,
                            ),
                            buildStatCard(
                              '$completedCount',
                              'Selesai',
                              Icons.check_circle,
                            ),
                            buildStatCard(
                              '$totalCredits',
                              'Total SKS',
                              Icons.stacked_bar_chart,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const GreetingCard(),
                      ],
                    ),
                  ),
                ),
              ),
              // Bagian bawah: list course dari JSON
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index] as Map<String, dynamic>;
                    final status = course['status'] as String;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: Icon(
                          status == 'done'
                              ? Icons.check_circle
                              : status == 'active'
                                  ? Icons.play_circle
                                  : Icons.schedule,
                          color: status == 'done'
                              ? Colors.green
                              : status == 'active'
                                  ? Colors.blue
                                  : Colors.orange,
                        ),
                        title: Text(course['title'] as String),
                        subtitle: Text(
                          '${course['code']} • ${course['credits']} SKS • ${course['lecturer']}',
                        ),
                        trailing: Text(status),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}