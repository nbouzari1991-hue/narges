import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class OCRReviewScreen extends StatefulWidget {
  @override
  _OCRReviewScreenState createState() => _OCRReviewScreenState();
}

class _OCRReviewScreenState extends State<OCRReviewScreen> {
  XFile? imageFile;
  String ocrText = '';

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    setState(() => imageFile = img);
    if (img != null) {
      var uri = Uri.parse('http://10.0.2.2:8000/ocr/upload');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', img.path));
      var streamed = await request.send();
      var res = await http.Response.fromStream(streamed);
      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        setState(() => ocrText = body['text'] ?? '');
      } else {
        setState(() => ocrText = 'خطا در OCR');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OCR - بررسی دفترچه')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton.icon(onPressed: pickImage, icon: Icon(Icons.camera_alt), label: Text('عکس بگیر')),
            SizedBox(height:8),
            Text('متن استخراج‌شده:'),
            Expanded(child: SingleChildScrollView(child: Text(ocrText)))
          ],
        ),
      ),
    );
  }
}
