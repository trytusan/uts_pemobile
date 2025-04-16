import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uts_aplication/models/uts_models.dart';
import 'package:uts_aplication/services/api.dart';

class EditReportPage extends StatefulWidget {
  final Report report;

  const EditReportPage({super.key, required this.report});

  @override
  State<EditReportPage> createState() => _EditReportPageState();
}

class _EditReportPageState extends State<EditReportPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nimController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  double _rating = 3;
  File? _selectedImage;
  String? _selectedDivision;
  String? _selectedPriority;

  final List<String> _divisions = ['Billing', 'Tech', 'OPS', 'Sales'];
  final List<String> _priorities = ['Low', 'Medium', 'High', 'Critical'];

  @override
  void initState() {
    super.initState();
    _nimController = TextEditingController(text: widget.report.nim);
    _titleController = TextEditingController(text: widget.report.titleIssues);
    _descriptionController = TextEditingController(text: widget.report.descriptionIssues);
    _rating = double.tryParse(widget.report.rating) ?? 3;

    _selectedDivision = _divisions.contains(widget.report.divisionDepartmentName)
        ? widget.report.divisionDepartmentName
        : null;

    _selectedPriority = _priorities.contains(widget.report.priorityName)
        ? widget.report.priorityName
        : null;
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
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
                title: const Text('Capture with Camera'),
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

  void _submitEdit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await DataListService().updateReport(
          idCustomerService: widget.report.idCustomerService,
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
            const SnackBar(content: Text('Report updated successfully')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update report: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text("Edit Report"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nimController,
                    decoration: const InputDecoration(
                      labelText: 'NIM',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'NIM cannot be empty' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Issue Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Title cannot be empty' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Issue Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    validator: (value) => value!.isEmpty ? 'Description is required' : null,
                  ),
                  const SizedBox(height: 16),
                  Text('Rating (1–5): ${_rating.toInt()}'),
                  Slider(
                    min: 1,
                    max: 5,
                    divisions: 4,
                    value: _rating,
                    label: _rating.toInt().toString(),
                    activeColor: Colors.blueAccent,
                    onChanged: (val) {
                      setState(() {
                        _rating = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text("Select Image"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                    onPressed: _pickImage,
                  ),
                  if (_selectedImage != null)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedDivision,
                    decoration: const InputDecoration(
                      labelText: 'Division',
                      border: OutlineInputBorder(),
                    ),
                    items: _divisions.map((div) {
                      return DropdownMenuItem(value: div, child: Text(div));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedDivision = val),
                    validator: (val) => val == null ? 'Please select a division' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: _priorities.map((prior) {
                      return DropdownMenuItem(value: prior, child: Text(prior));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedPriority = val),
                    validator: (val) => val == null ? 'Please select a priority' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitEdit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Save Changes", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
