import 'package:flutter/material.dart';
import 'package:uts_aplication/ui_planease/form_notula.dart';
import 'package:uts_aplication/ui_planease/notula_detail.dart';

class NotulaPage extends StatefulWidget {
  const NotulaPage({super.key});

  @override
  State<NotulaPage> createState() => _NotulaPageState();
}

class _NotulaPageState extends State<NotulaPage> {
  String searchQuery = '';
  String selectedYear = 'Semua';

  final List<Map<String, dynamic>> notulaList = [
    {
      'judul': 'Rapat Evaluasi Kinerja',
      'tanggal': '12 Januari 2024',
      'tahun': '2024',
      'ringkasan': 'Evaluasi seluruh kegiatan semester ganjil.',
    },
    {
      'judul': 'Persiapan Kegiatan Bakti Sosial',
      'tanggal': '8 Mei 2025',
      'tahun': '2025',
      'ringkasan': 'Diskusi teknis dan pembagian tugas.',
    },
    {
      'judul': 'Rapat Anggaran',
      'tanggal': '20 Februari 2023',
      'tahun': '2023',
      'ringkasan': 'Penyusunan anggaran tahun berjalan.',
    },
  ];

  List<String> get availableYears {
    final Set<String> years =
        notulaList.map((item) => item['tahun'] as String).toSet();
    return ['Semua', ...years.toList()..sort()];
  }

  List<Map<String, dynamic>> get filteredNotula {
    return notulaList.where((item) {
      final matchesSearch = item['judul']
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          item['ringkasan'].toLowerCase().contains(searchQuery.toLowerCase());

      final matchesYear =
          selectedYear == 'Semua' || item['tahun'] == selectedYear;

      return matchesSearch && matchesYear;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // ✅ APPBAR DENGAN TOMBOL KEMBALI
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
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.description, color: Colors.white),
            const SizedBox(width: 10),
            const Text(
              'Notula Rapat',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      // 🔍 FILTER DAN DAFTAR
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari judul atau ringkasan...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Tahun:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                DropdownButton<String>(
                  value: selectedYear,
                  borderRadius: BorderRadius.circular(12),
                  items: availableYears.map((year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredNotula.isEmpty
                  ? const Center(
                      child: Text(
                        '😕 Tidak ada notula ditemukan.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredNotula.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = filteredNotula[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    NotulaDetailPage(notula: item),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal.shade100,
                                child: const Icon(Icons.description,
                                    color: Colors.teal),
                              ),
                              title: Text(
                                item['judul'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF263238),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(item['ringkasan'],
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 6),
                                  Text(
                                    '📅 ${item['tanggal']}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // ➕ TOMBOL TAMBAH NOTULA
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF263238),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahNotulaPage()),
          );
        },
        tooltip: 'Tambah Notula',
        child: const Icon(Icons.add),
      ),
    );
  }
}
