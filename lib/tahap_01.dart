import 'package:flutter/material.dart';
import 'identity.dart';

class Tahap1 extends StatelessWidget {
  const Tahap1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 1 - Hard-coded vs Fleksibel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('A. Width tetap 500 (bermasalah)'),
            Row(
              children: [
                Container(
                  width: 500,
                  color: Colors.red.shade100,
                  padding: const EdgeInsets.all(16),
                  child: Text('$studentId - $studentName'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('B. Fleksibel dengan Expanded'),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.green.shade100,
                    padding: const EdgeInsets.all(16),
                    child: Text('$studentId - $studentName'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}