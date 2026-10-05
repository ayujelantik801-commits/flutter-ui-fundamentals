// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import 'course_data.dart';
import 'identity.dart';

class Tahap9ListPage extends StatefulWidget {
  const Tahap9ListPage({super.key});

  @override
  State<Tahap9ListPage> createState() => _Tahap9ListPageState();
}

class _Tahap9ListPageState extends State<Tahap9ListPage> {
  late Future<List<Map<String, dynamic>>> coursesFuture;

  @override
  void initState() {
    super.initState();
    coursesFuture = loadCourses();
  }

  Future<void> openDetail(Map<String, dynamic> course) async {
    // await: tunggu sampai halaman detail ditutup, lalu ambil hasilnya
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => Tahap9DetailPage(course: course)),
    );

    // Cek mounted sebelum memakai context setelah await
    if (!mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${course['title']} ditambahkan ke favorit'),
          duration: const Duration(seconds: 10),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 9 - Returning Data')),
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
                return ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text(course['title'] as String),
                        subtitle: Text(
                          '${course['code']} • ${course['credits']} SKS',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => openDetail(course),
                      ),
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

class Tahap9DetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const Tahap9DetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Course')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course['title'] as String,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Kode: ${course['code']}'),
            Text('SKS: ${course['credits']}'),
            Text('Status: ${course['status']}'),
            Text('Dosen: ${course['lecturer']}'),
            const Divider(height: 32),
            const Text('$studentId - $studentName'),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  icon: const Icon(Icons.favorite),
                  label: const Text('Favorite'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Kembali'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}