// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 5: ChangeNotifier untuk shared state course (favorites).
import 'package:flutter/foundation.dart';

class CourseProvider extends ChangeNotifier {
  // Single source of truth untuk course yang difavoritkan
  final Set<String> favorites = {};

  bool isFavorite(String code) => favorites.contains(code);

  void toggleFavorite(String code) {
    if (favorites.contains(code)) {
      favorites.remove(code);
    } else {
      favorites.add(code);
    }
    // Wajib dipanggil setelah state berubah agar listener (UI) diberi tahu
    notifyListeners();
  }
}