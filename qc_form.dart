import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class QCFormScreen extends StatefulWidget {
  @override
  _QCFormScreenState createState() => _QCFormScreenState();
}

class _QCFormScreenState extends State<QCFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String inspector = '';
  String defectType = 'بدون عیب';
  double thickness = 0.0;
  XFile? imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    setState(() => imageFile = image);
  }

  Future<void> submitQC() async {
    var uri = Uri.parse('http://10.0.2.2:8000/qc/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['inspector'] = inspector;
    request.fields['defect_type'] = defectType;
    request.fields['thickness'] = thickness.toString();
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('file', imageFile!.path));
    }
    var streamed = await request.send();
    var res = await http.Response.fromStream(streamed);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('QC ذخیره شد')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطا در ذخیره QC')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('فرم QC')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'بازرس (Inspector)'),
                onChanged: (v) => inspector = v,
              ),
              DropdownButtonFormField<String>(
                value: defectType,
                items: ['بدون عیب','حباب','شِرِه','خش','سایر'].map((s) => DropdownMenuItem(child: Text(s), value: s)).toList(),
                onChanged: (v) => setState(() => defectType = v ?? 'بدون عیب'),
                decoration: InputDecoration(labelText: 'نوع عیب'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ضخامت اندازه‌گیری شده (µm)'),
                keyboardType: TextInputType.number,
                onChanged: (v) => thickness = double.tryParse(v ?? '0') ?? 0.0,
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(onPressed: pickImage, icon: Icon(Icons.camera_alt), label: Text('گرفتن عکس')),
              SizedBox(height: 8),
              ElevatedButton(onPressed: submitQC, child: Text('ثبت QC')),
            ],
          ),
        ),
      ),
    );
  }
}
