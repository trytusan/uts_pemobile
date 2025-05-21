import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uts_aplication/models/petani_models.dart';
import 'package:uts_aplication/services/apipetani.dart';
import 'package:uts_aplication/models/kelompok_models.dart';

class PetaniForm extends StatefulWidget {
  final Petani? petani;

  const PetaniForm({super.key, this.petani});

  @override
  State<PetaniForm> createState() => _PetaniFormState();
}

class _PetaniFormState extends State<PetaniForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController telpController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  String idKelompok = '';
  String? _selectedStatus;
  String idPenjual = '';
  List<Kelompok> _kelompok = [];
  final String baseUrl = 'https://dev.wefgis.com/';

  @override
  void initState() {
    super.initState();
    getKelompok();
    if (widget.petani != null) {
      idPenjual = widget.petani!.idPenjual;
      namaController.text = widget.petani!.nama;
      nikController.text = widget.petani!.nik;
      alamatController.text = widget.petani!.alamat;
      telpController.text = widget.petani!.telp;
      idKelompok = widget.petani!.idKelompokTani;
      _selectedStatus = widget.petani!.status;
    } else {
      _selectedStatus = 'Y';
    }
  }

  void getKelompok() async {
    final response = await ApiStatic.getKelompokTani();
    setState(() {
      _kelompok = response.toList();
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _image = File(picked.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final isEdit = widget.petani != null;
    final Map<String, String> data = {
      'id_penjual': widget.petani?.idPenjual.toString() ?? '127',
      'id_kelompok_tani': idKelompok,
      'nama': namaController.text,
      'nik': nikController.text,
      'alamat': alamatController.text,
      'telp': telpController.text,
      'status': _selectedStatus ?? '',
    };

    final success = await ApiStatic.submitPetaniManual(
      data: data,
      foto: _image,
      isEdit: isEdit,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? (isEdit ? 'Data berhasil diperbarui' : 'Data berhasil ditambahkan')
            : 'Gagal menyimpan data'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) Navigator.pop(context);
  }

  @override
  void dispose() {
    namaController.dispose();
    nikController.dispose();
    alamatController.dispose();
    telpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.petani != null ? 'Edit Petani' : 'Tambah Petani'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Foto profil
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue.withOpacity(0.3), width: 2),
                ),
                child: ClipOval(
                  child: _image != null
                      ? Image.file(_image!, fit: BoxFit.cover)
                      : (widget.petani != null && widget.petani!.foto.isNotEmpty
                          ? Image.network('$baseUrl${widget.petani!.foto}', fit: BoxFit.cover)
                          : Icon(Icons.person, size: 60, color: Colors.grey[400])),
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt, color: Colors.blue),
                label: const Text("Pilih / Ganti Foto", style: TextStyle(color: Colors.blue)),
              ),

              const SizedBox(height: 20),
              _buildTextField(namaController, 'Nama', true),
              const SizedBox(height: 16),
              _buildTextField(nikController, 'NIK', true),
              const SizedBox(height: 16),
              _buildTextField(alamatController, 'Alamat'),
              const SizedBox(height: 16),
              _buildTextField(telpController, 'Telepon'),
              const SizedBox(height: 16),
              _buildKelompokDropdown(),
              const SizedBox(height: 16),
              _buildStatusRadio(),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  widget.petani != null ? 'Update' : 'Save',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, [bool required = false]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: required ? (value) => value!.isEmpty ? 'Wajib diisi' : null : null,
    );
  }

  Widget _buildKelompokDropdown() {
    return DropdownButtonFormField<String>(
      value: idKelompok.isEmpty ? null : idKelompok,
      decoration: InputDecoration(
        labelText: 'Kelompok Tani',
        labelStyle: const TextStyle(color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: _kelompok.map((item) {
        return DropdownMenuItem(
          value: item.idKelompokTani,
          child: Text(item.namaKelompok),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          idKelompok = value!;
        });
      },
      validator: (value) => value == null ? "Wajib diisi" : null,
    );
  }

  Widget _buildStatusRadio() {
    return FormField<String>(
      validator: (_) => _selectedStatus == null ? 'Status wajib dipilih' : null,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue)),
          RadioListTile<String>(
            title: const Text('Y'),
            value: 'Y',
            groupValue: _selectedStatus,
            activeColor: Colors.blue,
            onChanged: (val) => setState(() => _selectedStatus = val),
          ),
          RadioListTile<String>(
            title: const Text('N'),
            value: 'N',
            groupValue: _selectedStatus,
            activeColor: Colors.blue,
            onChanged: (val) => setState(() => _selectedStatus = val),
          ),
          if (field.hasError)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                field.errorText!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
