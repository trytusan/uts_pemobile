import 'package:flutter/material.dart';
import 'package:uts_aplication/ui_planease/form_agenda.dart';
import 'package:uts_aplication/ui_planease/polling_page.dart';

class VotingAgendaPage extends StatelessWidget {
  const VotingAgendaPage({super.key});

  final List<Map<String, dynamic>> agendaList = const [
    {
      'judul': 'Rapat Kerja Tahunan',
      'deskripsi': 'Membahas program kerja dan anggaran tahunan organisasi.',
      'tanggal': '24 Mei 2025',
    },
    {
      'judul': 'Pelatihan Kepemimpinan',
      'deskripsi': 'Pelatihan internal untuk pengurus baru dan calon pemimpin.',
      'tanggal': '30 Mei 2025',
    },
    {
      'judul': 'Bakti Sosial',
      'deskripsi': 'Kegiatan pengabdian masyarakat di desa binaan.',
      'tanggal': '5 Juni 2025',
    },
  ];

  final Map<String, List<String>> pilihanTema = const {
    'Rapat Kerja Tahunan': [
      'Sinergi & Kolaborasi',
      'Efisiensi & Transparansi',
      'Inovasi & Aksi Nyata',
    ],
    'Pelatihan Kepemimpinan': [
      'Leadership Berbasis Nilai',
      'Pemimpin Adaptif',
      'Mentoring & Coaching',
    ],
    'Bakti Sosial': [
      'Berbagi Itu Indah',
      'Aksi Nyata untuk Negeri',
      'Melayani dengan Hati',
    ],
  };

  void _showPilihanTema(BuildContext contextRoot, String agendaJudul) {
    final List<String> opsi = pilihanTema[agendaJudul] ?? [];

    showDialog(
      context: contextRoot,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Pilih Tema untuk "$agendaJudul"',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  opsi.map((tema) {
                    return ListTile(
                      leading: const Icon(Icons.how_to_vote),
                      title: Text(tema),
                      onTap: () {
                        Navigator.pop(context);

                        ScaffoldMessenger.of(contextRoot).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Kamu memilih: "$tema" untuk $agendaJudul',
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.green.shade700,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }

  Color _getCardColor(int index) {
    final colors = [
      Colors.teal.shade50,
      Colors.blue.shade50,
      Colors.orange.shade50,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF263238), Color(0xFF455A64)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const PollingPage()),
                  (route) => false,
                );
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.how_to_vote, color: Colors.white),
            const SizedBox(width: 10),
            const Text(
              'Voting Agenda',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: agendaList.length,
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          final agenda = agendaList[index];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: _getCardColor(index),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agenda['judul'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263238),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    agenda['deskripsi'],
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '📅 Tanggal: ${agenda['tanggal']}',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          () => _showPilihanTema(context, agenda['judul']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF263238),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.how_to_vote),
                      label: const Text(
                        'Vote Sekarang',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // ✅ Tambahkan FloatingActionButton di sini
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF263238),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahAgendaPage()),
          );
        },
        tooltip: 'Tambah Agenda',
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
