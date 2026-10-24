// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
// TAHAP 6: Form Create Course (POST).
// TAHAP 7: Mode Edit (PUT): data lama terisi, code read-only.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseFormPage extends StatefulWidget {
  const CourseFormPage({super.key, this.course});

  // null = mode Create, terisi = mode Edit
  final Course? course;

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeCtrl;
  late final TextEditingController _titleCtrl;
  late final TextEditingController _creditsCtrl;
  late String _status;

  bool get _isEdit => widget.course != null;

  @override
  void initState() {
    super.initState();
    final c = widget.course;
    _codeCtrl = TextEditingController(text: c?.code ?? '');
    _titleCtrl = TextEditingController(text: c?.title ?? '');
    _creditsCtrl = TextEditingController(text: c?.credits.toString() ?? '');
    _status = c?.status ?? 'planned';
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _titleCtrl.dispose();
    _creditsCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CourseProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final course = Course(
      id: widget.course?.id,
      code: _codeCtrl.text.trim().toUpperCase(),
      title: _titleCtrl.text.trim(),
      credits: int.parse(_creditsCtrl.text.trim()),
      status: _status,
      lecturer: widget.course?.lecturer ?? Course.defaultLecturer,
    );

    try {
      if (_isEdit) {
        await provider.updateCourse(widget.course!.id!, course);
      } else {
        await provider.createCourse(course);
      }
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            _isEdit
                ? 'Course ${course.code} berhasil diperbarui'
                : 'Course ${course.code} berhasil ditambahkan',
          ),
        ),
      );
      navigator.pop();
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final isSaving = provider.isSaving;

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Course' : 'Tambah Course')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeCtrl,
                readOnly: _isEdit,
                decoration: InputDecoration(
                  labelText: _isEdit
                      ? 'Kode (tidak dapat diubah)'
                      : 'Kode (contoh: MOB05)',
                  border: const OutlineInputBorder(),
                  filled: _isEdit,
                ),
                validator: (v) {
                  final value = (v ?? '').trim().toUpperCase();
                  if (value.isEmpty) return 'Kode wajib diisi';
                  if (!_isEdit) {
                    final exists =
                        provider.courses.any((c) => c.code == value);
                    if (exists) return 'Kode sudah dipakai';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _creditsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'SKS',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'SKS wajib diisi';
                  if (int.tryParse(value) == null) return 'SKS harus angka';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'planned', child: Text('planned')),
                  DropdownMenuItem(value: 'active', child: Text('active')),
                  DropdownMenuItem(value: 'done', child: Text('done')),
                ],
                onChanged: isSaving
                    ? null
                    : (v) => setState(() => _status = v ?? 'planned'),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: isSaving ? null : _submit,
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(isSaving ? 'Menyimpan...' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}