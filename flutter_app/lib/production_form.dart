import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductionFormScreen extends StatefulWidget {
  @override
  _ProductionFormScreenState createState() => _ProductionFormScreenState();
}

class _ProductionFormScreenState extends State<ProductionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String shift = 'صبح';
  String moldId = '';
  int quantity = 0;

  Future<void> submit() async {
    final body = {
      "production_date": DateTime.now().toIso8601String(),
      "shift": shift,
      "mold_id": moldId,
      "quantity_produced": quantity
    };
    try {
      final res = await http.post(Uri.parse('http://10.0.2.2:8000/production/'),
          headers: {'Content-Type': 'application/json'}, body: json.encode(body));
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('رکورد ذخیره شد')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطا در ذخیره')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطا: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('فرم ثبت تولید')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: shift,
                items: ['صبح','عصر','شب'].map((s) => DropdownMenuItem(child: Text(s), value: s)).toList(),
                onChanged: (v) => setState(() => shift = v ?? 'صبح'),
                decoration: InputDecoration(labelText: 'شیفت'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'شماره قالب (Mold ID)'),
                onChanged: (v) => moldId = v,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'تعداد تولیدی'),
                keyboardType: TextInputType.number,
                onChanged: (v) => quantity = int.tryParse(v ?? '0') ?? 0,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: submit,
                child: Text('ثبت'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
