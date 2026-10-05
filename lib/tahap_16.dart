// Nama: I Gusti Ayu Putu Jelantik | NIM: 2415051053
import 'package:flutter/material.dart';
import 'identity.dart';

// false = versi BERMASALAH, true = versi PERBAIKAN
const bool fixA = true;
const bool fixB = true;
const bool fixC = true;
const bool fixD = true;

class Tahap16 extends StatelessWidget {
  const Tahap16({super.key});

  @override
  Widget build(BuildContext context) {
    Widget item(String title, Widget page) {
      return Card(
        child: ListTile(
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 16 - Debugging')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            item('Kasus A - Row overflow', const CaseAPage()),
            item('Kasus B - ListView di Column', const CaseBPage()),
            item('Kasus C - Keyboard overflow', const CaseCPage()),
            item('Kasus D - Navigasi ganda', const CaseDPage()),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// KASUS A: RenderFlex overflow pada Row dengan teks panjang
// ---------------------------------------------------------------
class CaseAPage extends StatelessWidget {
  const CaseAPage({super.key});

  @override
  Widget build(BuildContext context) {
    const longText = '$studentId - $studentName - teks sangat panjang '
        'untuk menguji overflow pada Row di layar sempit';

    return Scaffold(
      appBar: AppBar(title: const Text('Kasus A')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info),
            const SizedBox(width: 8),
            // Perbaikan: Expanded memberi Text lebar terbatas, sehingga
            // teks membungkus ke baris berikutnya
            fixA
                ? const Expanded(child: Text(longText))
                : const Text(longText),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// KASUS B: ListView di dalam Column tanpa Expanded
// ---------------------------------------------------------------
class CaseBPage extends StatelessWidget {
  const CaseBPage({super.key});

  @override
  Widget build(BuildContext context) {
    final list = ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) =>
          ListTile(title: Text('Item ${index + 1}')),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Kasus B')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('$studentId - $studentName'),
          ),
          // Perbaikan: Expanded memberi ListView tinggi yang terbatas
          fixB ? Expanded(child: list) : list,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// KASUS C: form dekat bagian bawah layar + keyboard
// ---------------------------------------------------------------
class CaseCPage extends StatelessWidget {
  const CaseCPage({super.key});

  Widget buildFields() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final label in ['Nama', 'NIM', 'Komentar'])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Kirim'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasus C')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (!fixC) ...[
              // Bermasalah: Spacer mendorong form ke bawah, tapi saat ruang
              // menyempit (keyboard muncul) isinya melebihi tinggi layar
              const Spacer(),
              buildFields(),
            ] else
              // Perbaikan: form tetap di bawah saat ruang cukup,
              // dan bisa digulir saat ruang menyempit
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: buildFields(),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// KASUS D: navigasi ganda akibat tombol ditekan berulang
// ---------------------------------------------------------------
int targetInstanceCounter = 0;

class CaseDPage extends StatefulWidget {
  const CaseDPage({super.key});

  @override
  State<CaseDPage> createState() => _CaseDPageState();
}

class _CaseDPageState extends State<CaseDPage> {
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    targetInstanceCounter = 0;
  }

  Future<void> openTarget() async {
    // Perbaikan: abaikan tap berikutnya selama proses berjalan
    if (fixD) {
      if (isNavigating) return;
      setState(() => isNavigating = true);
    }

    await Future.delayed(const Duration(seconds: 1)); // simulasi proses
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TargetPage()),
    );
    if (!mounted) return;

    if (fixD) setState(() => isNavigating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasus D')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('$studentId - $studentName'),
            const SizedBox(height: 16),
            ElevatedButton(
              // onPressed null = tombol nonaktif
              onPressed: (fixD && isNavigating) ? null : openTarget,
              child: Text(
                (fixD && isNavigating) ? 'Memproses...' : 'Buka Halaman Tujuan',
              ),
            ),
            const SizedBox(height: 8),
            const Text('Tekan tombol 3x dengan cepat'),
          ],
        ),
      ),
    );
  }
}

class TargetPage extends StatefulWidget {
  const TargetPage({super.key});

  @override
  State<TargetPage> createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  late final int instanceId;

  @override
  void initState() {
    super.initState();
    instanceId = ++targetInstanceCounter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Halaman Tujuan #$instanceId')),
      body: Center(
        child: Text(
          'Instance ke-$instanceId\n$studentId - $studentName',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}