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

## Endpoint REST API (Pertemuan 7)
- Base URL: http://localhost:3000
- Endpoint: GET /courses
- Status code: 200 OK
- Resource: courses
- Field JSON: id, code, title, credits, status
- Catatan: memakai json-server lokal (db.json) sebagai API latihan.

## Database Supabase (Pertemuan 7)
- Tabel: courses (id, code, title, credits, status, created_at)
- status dibatasi lewat CHECK: planned / active / done
- Skema lengkap ada di supabase/schema.sql
- RLS aktif dengan policy permisif untuk anon, HANYA untuk praktikum
  (bukan pola produksi).

  ## Course Data Manager (Pertemuan 7)

Aplikasi Flutter untuk mengelola data mata kuliah (CRUD) yang terhubung ke backend.
Pengembangan dari Course Explorer v2 (Pertemuan 5-6): navigasi responsif, halaman
detail, dan favorites tetap berfungsi.

Identitas: 2415051053 - I Gusti Ayu Putu Jelantik

### Fitur
- Read, Create, Update, Delete (dengan dialog konfirmasi saat hapus)
- State loading, empty, error (dengan tombol Retry)
- SnackBar untuk operasi berhasil/gagal
- Favorites memakai code sebagai kunci, konsisten di tab Courses dan Favorites

### Backend yang digunakan
- Aktif: Supabase (tabel courses) lewat CourseSupabaseService
- Alternatif: REST API lokal (json-server) lewat CourseApiService
- Sumber data dipilih hanya di lib/main.dart (satu baris)

### Arsitektur singkat
Screen/Widget -> CourseProvider -> CourseRepository -> CourseDataSource
(kontrak) -> CourseSupabaseService atau CourseApiService.
Model: lib/models/course.dart. Screen dan provider tidak berisi kode HTTP/Supabase.

### Cara menjalankan
1. Jalankan `flutter pub get`.
2. Isi URL dan publishable key project Supabase di lib/config/supabase_config.dart.
3. Buat tabel dengan menjalankan supabase/schema.sql di SQL Editor Supabase.
4. Jalankan `flutter run -d chrome`.
5. (Opsional, mode REST) jalankan json-server pada port 3000, lalu ganti data
   source di lib/main.dart menjadi CourseApiService(apiBaseUrl).

### Keamanan
- Hanya memakai publishable/anon key. Tidak ada service_role atau secret key.
- RLS aktif; policy permisif untuk anon hanya untuk praktikum, bukan pola produksi.
- Validasi form tidak menggantikan validasi backend (CHECK constraint, RLS).