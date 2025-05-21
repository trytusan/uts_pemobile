import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TambahNotulaPage extends StatefulWidget {
  const TambahNotulaPage({super.key});

  @override
  State<TambahNotulaPage> createState() => _TambahNotulaPageState();
}

class _TambahNotulaPageState extends State<TambahNotulaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  void _pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('id', 'ID'),
    );

    if (picked != null) {
      setState(() {
        _tanggalController.text = DateFormat('dd MMMM yyyy', 'id_ID').format(picked);
      });
    }
  }

  void _simpanNotula() {
    if (_formKey.currentState!.validate()) {
      final notula = {
        'judul': _judulController.text.trim(),
        'tanggal': _tanggalController.text.trim(),
        'deskripsi': _deskripsiController.text.trim(),
      };

      print("📝 Notula Baru:");
      print(notula);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Notula berhasil disimpan."),
          backgroundColor: Colors.green,
        ),
      );

      _formKey.currentState!.reset();
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _tanggalController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.note_alt_outlined, color: Colors.white),
            const SizedBox(width: 10),
            const Text(
              'Tambah Notula',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("📝 Nama Kegiatan", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Contoh: Rapat Bulanan Mei",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Wajib diisi." : null,
              ),
              const SizedBox(height: 16),

              const Text("📅 Tanggal Kegiatan", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                onTap: _pilihTanggal,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Pilih tanggal...",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                validator: (value) => value!.isEmpty ? "Wajib dipilih." : null,
              ),
              const SizedBox(height: 16),

              const Text("🧾 Deskripsi Notula", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _deskripsiController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Ringkasan hasil rapat...",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Wajib diisi." : null,
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _simpanNotula,
                icon: const Icon(Icons.save),
                label: const Text("Simpan Notula"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF263238),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
