# Course Explorer v2

**Nama:** I Gusti Ayu Putu Jelantik
**NIM:** 2415051053

Aplikasi Flutter untuk menampilkan daftar course, menandai course favorit, dan
melihat detail course. Pertemuan 6 berfokus pada **State Management** (Provider)
dan **Architecture** (pemisahan tanggung jawab per layer).

## Fitur

- Responsive navigation: `NavigationBar` (layar sempit) dan `NavigationRail` (layar lebar)
- Daftar course 1, 2, atau 3 kolom sesuai lebar layar
- Loading, error (dengan tombol coba lagi), dan success state
- Favorit yang konsisten di Courses, Detail, Favorites, Home, dan Profile
- Nama dan NIM tampil di setiap halaman

## Arah dependency

```
Screen / Widget  ->  Provider  ->  Repository  ->  Service  ->  Data (JSON asset)
                          \             \
                           +-------------+--->  Model (Course)
```

Aturannya: layer di kiri boleh mengenal layer di kanan, tidak sebaliknya.
UI tidak memanggil `rootBundle` atau `jsonDecode`, dan layer data tidak mengenal
widget maupun `BuildContext`.

## Struktur dan tanggung jawab folder

| Folder / File | Tanggung jawab |
|---|---|
| `lib/main.dart` | Titik masuk aplikasi. Merangkai `CourseService` -> `CourseRepository` -> `CourseProvider`, lalu memasang `ChangeNotifierProvider` di root. |
| `lib/app.dart` | `MaterialApp`, tema, dan halaman awal. |
| `lib/student_info.dart` | Konstanta identitas (nama dan NIM) agar konsisten di seluruh UI. |
| `lib/models/` | Bentuk data. `Course` beserta `fromJson` dan `toJson`. Tidak bergantung pada layer lain. |
| `lib/services/` | Akses sumber data. `CourseService` membaca dan mem-parse JSON asset. Tidak mengandung widget atau `BuildContext`. Bila sumber data pindah ke API, cukup bagian ini yang berubah. |
| `lib/repositories/` | Abstraksi data untuk Provider. `CourseRepository` menyediakan `getCourses()` tanpa membuka detail sumber data. |
| `lib/providers/` | State dan logika aplikasi. `CourseProvider` menyimpan `courses`, `isLoading`, `error`, dan `favorites`, serta memanggil `notifyListeners()` saat state berubah. Tidak menyimpan `BuildContext`. |
| `lib/screens/` | Halaman utuh: `ExplorerShell` (navigasi), `HomeScreen`, `CoursesScreen`, `FavoritesScreen`, `CourseDetailScreen`, `ProfileScreen`. `course_actions.dart` berisi aksi UI yang dipakai bersama (toggle favorit dan buka detail). |
| `lib/widgets/` | Komponen reusable yang tidak tahu asal datanya: `IdentityBar` dan `CourseCard`. |
| `lib/experiments/` | Eksperimen per tahap praktikum (setState, lifting state up, ValueNotifier, ChangeNotifier, service, repository, debugging). Tidak dipakai aplikasi utama. |

## Pembagian state

| State | Jenis | Lokasi |
|---|---|---|
| `courses`, `isLoading`, `error` | Shared (async) | `CourseProvider` |
| `favorites` | Shared | `CourseProvider` |
| `selectedIndex` (tab aktif) | Local | `ExplorerShell` |
| `showLecturer` (tampil/sembunyi dosen) | Local | `CourseDetailScreen` |

Pemakaian Provider di UI:

- `context.watch` / `Consumer`: membaca state dan ikut rebuild saat berubah.
- `context.read`: hanya memanggil aksi (misalnya pada `onPressed`), tanpa rebuild.

## File peninggalan Pertemuan sebelumnya

File di root `lib/` berikut adalah latihan dan pendukung Pertemuan sebelumnya
dan tidak menjadi bagian dari arsitektur Course Explorer v2: `tahap_*.dart`,
`identity.dart`, dan `course_data.dart`. File-file ini masih dipertahankan
karena masih di-import oleh file latihan lama (misalnya `FeedbackForm` pada
`tahap_13.dart` yang ditampilkan di halaman Profile). Course Explorer v2 tidak
memakai `course_data.dart`; pembacaan data sudah dipindah ke `CourseService`.

## Menjalankan aplikasi

```bash
flutter pub get
flutter run
```

Menjalankan satu eksperimen:

```bash
flutter run -t lib/experiments/tahap5_change_notifier.dart
```

## Tahap 17
Finalisasi worksheet state management dan architecture. Semua tahap 0-17 sudah di-commit dan di-push.