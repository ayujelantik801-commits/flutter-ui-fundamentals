// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import '../widgets/explorer_widgets.dart';
import 'courses_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

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
      const FavoritesScreen(),
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
                NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
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
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
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