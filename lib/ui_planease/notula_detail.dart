import 'package:flutter/material.dart';

class NotulaDetailPage extends StatelessWidget {
  final Map<String, dynamic> notula;

  const NotulaDetailPage({super.key, required this.notula});

  void _downloadPDF(BuildContext context) {
    // Ini hanya simulasi. Kamu bisa integrasikan dengan paket seperti printing, pdf, atau syncfusion.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔽 Fitur download PDF belum diaktifkan.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF263238),
                Color(0xFF455A64),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
        title: Row(
          children: const [
            Icon(Icons.description, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Detail Notula',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notula['judul'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '📅 ${notula['tanggal']}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'Ringkasan:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              notula['ringkasan'],
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            const Spacer(),

            // 🔽 Tombol Download PDF
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _downloadPDF(context),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Download sebagai PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF263238),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
