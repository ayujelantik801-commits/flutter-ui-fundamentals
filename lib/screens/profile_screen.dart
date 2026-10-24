// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../student_info.dart';
import '../tahap_13.dart' show FeedbackForm; // reusable widget #3

// ---------------------------------------------------------------
// PROFILE: identitas + form feedback (scrollable)
// TAHAP 7: Consumer pada satu bagian kecil (jumlah favorit)
// ---------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  studentName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Center(child: Text(studentId)),
              const SizedBox(height: 4),
              // Hanya baris ini yang dibangun ulang saat favorites berubah
              Consumer<CourseProvider>(
                builder: (context, provider, _) {
                  debugPrint('REBUILD: Profile favorite count (Consumer)');
                  return Center(
                    child: Text('Course favorit: ${provider.favorites.length}'),
                  );
                },
              ),
              const Divider(height: 32),
              const Text(
                'Kirim Feedback',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const FeedbackForm(),
            ],
          ),
        ),
      ),
    );
  }
}