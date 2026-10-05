// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import 'course_data.dart';
import 'explorer_widgets.dart';
import 'identity.dart';
import 'tahap_13.dart' show FeedbackForm; // reusable widget #3

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const ExplorerShell(),
    );
  }
}

// ---------------------------------------------------------------
// SHELL: adaptive navigation + state bersama (tab aktif & favorit)
// ---------------------------------------------------------------
class ExplorerShell extends StatefulWidget {
  const ExplorerShell({super.key});

  @override
  State<ExplorerShell> createState() => _ExplorerShellState();
}

class _ExplorerShellState extends State<ExplorerShell> {
  int selectedIndex = 0;
  final Set<String> favorites = {};
  late Future<List<Map<String, dynamic>>> coursesFuture;

  @override
  void initState() {
    super.initState();
    coursesFuture = loadCourses();
  }

  void onSelect(int index) => setState(() => selectedIndex = index);

  void toggleFavorite(String code) {
    setState(() {
      if (!favorites.remove(code)) favorites.add(code);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(favoriteCount: favorites.length),
      CoursesScreen(
        coursesFuture: coursesFuture,
        favorites: favorites,
        onToggleFavorite: toggleFavorite,
      ),
      ProfileScreen(favoriteCount: favorites.length),
    ];

    final body = Column(
      children: [
        const IdentityBar(),
        Expanded(child: pages[selectedIndex]),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 840;

        if (!isWide) {
          return Scaffold(
            appBar: AppBar(title: const Text('Course Explorer')),
            body: body,
            bottomNavigationBar: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onSelect,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.school), label: 'Courses'),
                NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Course Explorer')),
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: onSelect,
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.school),
                    label: Text('Courses'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text('Profile'),
                  ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: body),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------
// HOME
// ---------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  final int favoriteCount;
  const HomeScreen({super.key, required this.favoriteCount});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school, size: 64),
            const SizedBox(height: 12),
            const Text(
              'Selamat datang di Course Explorer',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('$studentId - $studentName'),
            const SizedBox(height: 16),
            Text('Course favorit: $favoriteCount'),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// COURSES: 1 kolom (compact), 2 kolom (medium), 3 kolom (expanded)
// ---------------------------------------------------------------
class CoursesScreen extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> coursesFuture;
  final Set<String> favorites;
  final void Function(String code) onToggleFavorite;

  const CoursesScreen({
    super.key,
    required this.coursesFuture,
    required this.favorites,
    required this.onToggleFavorite,
  });

  void toggleWithFeedback(BuildContext context, Map<String, dynamic> course) {
    final code = course['code'] as String;
    final wasFavorite = favorites.contains(code);
    onToggleFavorite(code);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            wasFavorite
                ? '${course['title']} dihapus dari favorit'
                : '${course['title']} ditambahkan ke favorit',
          ),
        ),
      );
  }

  Future<void> openDetail(
    BuildContext context,
    Map<String, dynamic> course,
  ) async {
    final code = course['code'] as String;
    final toggle = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(
          course: course,
          isFavorite: favorites.contains(code),
        ),
      ),
    );
    if (toggle == true && context.mounted) {
      toggleWithFeedback(context, course);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
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
            final width = constraints.maxWidth;

            Widget cardFor(Map<String, dynamic> course) {
              return CourseCard(
                course: course,
                isFavorite: favorites.contains(course['code']),
                onTap: () => openDetail(context, course),
                onToggleFavorite: () => toggleWithFeedback(context, course),
              );
            }

            // Compact: 1 kolom (list)
            if (width < 600) {
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: courses.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: cardFor(courses[index]),
                ),
              );
            }

            // Medium: 2 kolom, Expanded: 3 kolom
            final columns = width < 840 ? 2 : 3;
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 160,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) => cardFor(courses[index]),
            );
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------
// DETAIL: data diterima lewat constructor, hasil dikirim lewat pop
// ---------------------------------------------------------------
class CourseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;

  const CourseDetailScreen({
    super.key,
    required this.course,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Course')),
      body: Column(
        children: [
          const IdentityBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['title'] as String,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Kode: ${course['code']}'),
                  Text('SKS: ${course['credits']}'),
                  Text('Status: ${course['status']}'),
                  Text('Dosen: ${course['lecturer']}'),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    // true = minta halaman sebelumnya mengubah status favorit
                    onPressed: () => Navigator.pop(context, true),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    label: Text(
                      isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// PROFILE: identitas + form feedback (scrollable)
// ---------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  final int favoriteCount;
  const ProfileScreen({super.key, required this.favoriteCount});

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
              Center(child: Text('Course favorit: $favoriteCount')),
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