// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_provider.dart';
import 'explorer_widgets.dart';
import 'models/course.dart';
import 'identity.dart' hide studentName, studentId;
import 'student_info.dart';
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
// SHELL: adaptive navigation
//
// TAHAP 1 - KLASIFIKASI STATE:
//  1. favorites        -> SHARED (TAHAP 7: dipindah ke CourseProvider)
//  2. courses/isLoading/error -> SHARED (TAHAP 11: di CourseProvider)
//  3. selectedIndex    -> LOCAL  (hanya untuk navigasi shell)
//  4. showLecturer     -> LOCAL  (show/hide info dosen di Detail)
//  5. isWide (layout)  -> LOCAL  (turunan ukuran layar)
// ---------------------------------------------------------------
class ExplorerShell extends StatefulWidget {
  const ExplorerShell({super.key});

  @override
  State<ExplorerShell> createState() => _ExplorerShellState();
}

class _ExplorerShellState extends State<ExplorerShell> {
  int selectedIndex = 0; // local state

  void onSelect(int index) => setState(() => selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HomeScreen(),
      const CoursesScreen(),
      const ProfileScreen(),
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
// TAHAP 7: context.watch() -> membaca state DAN ikut rebuild saat berubah
// ---------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteCount = context.watch<CourseProvider>().favorites.length;
    debugPrint('REBUILD: HomeScreen (watch)');

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
// TAHAP 7:
//  - context.read()  -> dipakai di aksi (toggle, buka detail), tanpa listen
//  - Consumer        -> membungkus tiap card agar hanya card yang rebuild
// ---------------------------------------------------------------
class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  void toggleWithFeedback(BuildContext context, Course course) {
    final provider = context.read<CourseProvider>(); // read: hanya aksi
    final wasFavorite = provider.isFavorite(course.code);
    provider.toggleFavorite(course.code);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            wasFavorite
                ? '${course.title} dihapus dari favorit'
                : '${course.title} ditambahkan ke favorit',
          ),
        ),
      );
  }

  Future<void> openDetail(BuildContext context, Course course) async {
    final isFav = context.read<CourseProvider>().isFavorite(course.code);
    final toggle = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(
          course: course.toJson(),
          isFavorite: isFav,
        ),
      ),
    );
    if (toggle == true && context.mounted) {
      toggleWithFeedback(context, course);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TAHAP 11: UI hanya membaca state async dari provider
    final provider = context.watch<CourseProvider>();

    // 1) LOADING
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2) ERROR
    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Gagal memuat: ${provider.error}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => context.read<CourseProvider>().loadCourses(),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // 3) SUCCESS
    final courses = provider.courses;
    if (courses.isEmpty) {
      return const Center(child: Text('Belum ada course'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        Widget cardFor(Course course) {
          // Consumer: hanya bagian ini yang dibangun ulang saat notify
          return Consumer<CourseProvider>(
            builder: (context, p, _) {
              debugPrint('REBUILD: CourseCard ${course.code} (Consumer)');
              return CourseCard(
                course: course.toJson(),
                isFavorite: p.isFavorite(course.code),
                onTap: () => openDetail(context, course),
                onToggleFavorite: () => toggleWithFeedback(context, course),
              );
            },
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
  }
}

// ---------------------------------------------------------------
// DETAIL: data diterima lewat constructor, hasil dikirim lewat pop
// TAHAP 1: StatefulWidget untuk LOCAL STATE (showLecturer)
// ---------------------------------------------------------------
class CourseDetailScreen extends StatefulWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;

  const CourseDetailScreen({
    super.key,
    required this.course,
    required this.isFavorite,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  bool showLecturer = true; // LOCAL STATE (setState)

  @override
  Widget build(BuildContext context) {
    // TAHAP 8: Map<String, dynamic> diubah menjadi object Course bertipe jelas
    final course = Course.fromJson(widget.course);

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
                    course.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Kode: ${course.code}'),
                  Text('SKS: ${course.credits}'),
                  Text('Status: ${course.status}'),
                  if (showLecturer) Text('Dosen: ${course.lecturer}'),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => showLecturer = !showLecturer);
                    },
                    icon: Icon(
                      showLecturer ? Icons.visibility_off : Icons.visibility,
                    ),
                    label: Text(
                      showLecturer
                          ? 'Sembunyikan info dosen'
                          : 'Tampilkan info dosen',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    // true = minta halaman sebelumnya mengubah status favorit
                    onPressed: () => Navigator.pop(context, true),
                    icon: Icon(
                      widget.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    label: Text(
                      widget.isFavorite
                          ? 'Hapus dari Favorit'
                          : 'Tambah ke Favorit',
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