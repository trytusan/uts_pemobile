import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahAgendaPage extends StatefulWidget {
  const TambahAgendaPage({super.key});

  @override
  State<TambahAgendaPage> createState() => _TambahAgendaPageState();
}

class _TambahAgendaPageState extends State<TambahAgendaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _topikController = TextEditingController();
  final TextEditingController _opsiController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final List<Map<String, dynamic>> _opsiVoting = [];
  final ImagePicker _picker = ImagePicker();

  DateTime? _selectedDate;

  void _tambahOpsiTeks() {
    final opsi = _opsiController.text.trim();
    if (opsi.isNotEmpty) {
      setState(() {
        _opsiVoting.add({
          'type': 'text',
          'value': opsi,
        });
        _opsiController.clear();
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _opsiVoting.add({
          'type': 'image',
          'value': File(pickedFile.path),
        });
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _simpanAgenda() {
    if (_formKey.currentState!.validate()) {
      if (_opsiVoting.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tambahkan minimal satu opsi voting."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final data = {
        'judul': _judulController.text.trim(),
        'topik': _topikController.text.trim(),
        'tanggal': _dateController.text.trim(),
        'opsi': _opsiVoting,
      };

      print("✅ Agenda Voting Baru:");
      print(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Agenda voting berhasil disimpan."),
          backgroundColor: Colors.green,
        ),
      );

      _formKey.currentState!.reset();
      setState(() {
        _opsiVoting.clear();
        _dateController.clear();
        _selectedDate = null;
      });
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _topikController.dispose();
    _opsiController.dispose();
    _dateController.dispose();
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
            const Icon(Icons.edit_note, color: Colors.white),
            const SizedBox(width: 10),
            const Text(
              'Tambah Agenda Voting',
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
                  hintText: "Contoh: Bakti Sosial 2025",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Wajib diisi." : null,
              ),
              const SizedBox(height: 16),

              const Text("📌 Topik Voting", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _topikController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Contoh: Pilih Tanggal atau Desain Kaos",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Wajib diisi." : null,
              ),
              const SizedBox(height: 16),

              const Text("🗓️ Tanggal Agenda", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Pilih Tanggal",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) => value!.isEmpty ? "Wajib pilih tanggal." : null,
              ),
              const SizedBox(height: 16),

              const Text("📋 Opsi Voting", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _opsiController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Contoh: 1 Juni 2025 atau Kaos Biru",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _tambahOpsiTeks,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF263238),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Tambah Gambar Opsi"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF455A64),
                ),
              ),

              const SizedBox(height: 12),
              if (_opsiVoting.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("✅ Opsi Terdaftar:"),
                    const SizedBox(height: 6),
                    ..._opsiVoting.map((item) {
                      return ListTile(
                        leading: item['type'] == 'image'
                            ? Image.file(item['value'], width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.how_to_vote),
                        title: item['type'] == 'image'
                            ? const Text("Gambar Opsi")
                            : Text(item['value']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() => _opsiVoting.remove(item));
                          },
                        ),
                      );
                    }),
                  ],
                ),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _simpanAgenda,
                icon: const Icon(Icons.save),
                label: const Text("Simpan Agenda"),
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
