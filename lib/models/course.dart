class Course {
  static const String defaultLecturer = 'Dr. I Ketut Resika Arthana';

  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;
  final String lecturer;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
    this.lecturer = defaultLecturer,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: (json['status'] as String?) ?? 'planned',
      lecturer: (json['lecturer'] as String?) ?? defaultLecturer,
    );
  }

  // lecturer sengaja tidak dikirim: tabel API/Supabase hanya punya
  // kolom code, title, credits, status.
  Map<String, dynamic> toJson() => {
        'code': code,
        'title': title,
        'credits': credits,
        'status': status,
      };
}