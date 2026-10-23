// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 8: Model Course (data bertipe jelas + parsing JSON terpusat).

class Course {
  final String code;
  final String title;
  final int credits;
  final String status;
  final String lecturer;

  const Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
    this.lecturer = '',
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String,
      title: json['title'] as String,
      credits: (json['credits'] as num).toInt(),
      status: json['status'] as String,
      lecturer: (json['lecturer'] as String?) ?? '',
    );
  }
}