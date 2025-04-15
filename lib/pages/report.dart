import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:uts_aplication/services/api.dart';

class ReportFormPage extends StatefulWidget {
  const ReportFormPage({super.key});

  @override
  State<ReportFormPage> createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<ReportFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  double _rating = 3;
  File? _selectedImage;
  String? _selectedDivision;
  String? _selectedPriority;

  final List<String> _divisions = ['Billing', 'Tech', 'OPS', 'Sales'];
  final List<String> _priorities = ['Low', 'Medium', 'High', 'Critical'];

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Select from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() {
                      _selectedImage = File(picked.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker().pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    setState(() {
                      _selectedImage = File(picked.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await DataListService().createReport(
          nim: _nimController.text,
          titleIssues: _titleController.text,
          descriptionIssues: _descriptionController.text,
          rating: _rating.toInt(),
          imageFile: _selectedImage,
          idDivisionTarget: _divisions.indexOf(_selectedDivision!) + 1,
          idPriority: _priorities.indexOf(_selectedPriority!) + 1,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Report submitted successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        print('❌ Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit report: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Report")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(labelText: 'NIM'),
                validator: (value) => value!.isEmpty ? 'NIM is required' : null,
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Issue Title'),
                validator: (value) => value!.isEmpty ? 'Title is required' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Issue Description'),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 10),
              Text('Rating (1–5): ${_rating.toInt()}'),
              Slider(
                min: 1,
                max: 5,
                divisions: 4,
                value: _rating,
                label: _rating.toInt().toString(),
                onChanged: (val) {
                  setState(() {
                    _rating = val;
                  });
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text("Select Image"),
                onPressed: _pickImage,
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.file(_selectedImage!, height: 100),
                ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedDivision,
                decoration: const InputDecoration(labelText: 'Target Division'),
                items: _divisions.map((div) {
                  return DropdownMenuItem(value: div, child: Text(div));
                }).toList(),
                onChanged: (val) => setState(() => _selectedDivision = val),
                validator: (val) => val == null ? 'Please select a division' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: const InputDecoration(labelText: 'Priority Level'),
                items: _priorities.map((prior) {
                  return DropdownMenuItem(value: prior, child: Text(prior));
                }).toList(),
                onChanged: (val) => setState(() => _selectedPriority = val),
                validator: (val) => val == null ? 'Please select a priority' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Submit Report"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
