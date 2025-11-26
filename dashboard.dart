import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String summary = "در حال بارگذاری...";

  @override
  void initState() {
    super.initState();
    fetchSummary();
  }

  Future<void> fetchSummary() async {
    try {
      final res = await http.get(Uri.parse('http://10.0.2.2:8000/summary'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() => summary = data['text'] ?? 'خلاصه در دسترس نیست');
      } else {
        setState(() => summary = 'خطا در دریافت خلاصه');
      }
    } catch (e) {
      setState(() => summary = 'خطا: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('داشبورد GraniteBot'), actions: [
        IconButton(icon: Icon(Icons.settings), onPressed: () => Navigator.pushNamed(context,'/settings'))
      ]),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(child: ListTile(title: Text('خلاصه سریع'), subtitle: Text(summary))),
            SizedBox(height:12),
            Wrap(spacing:10, children: [
              ElevatedButton.icon(onPressed: ()=>Navigator.pushNamed(context,'/production'), icon: Icon(Icons.add), label: Text('ثبت تولید')),
              ElevatedButton.icon(onPressed: ()=>Navigator.pushNamed(context,'/qc'), icon: Icon(Icons.bug_report), label: Text('ثبت QC')),
              ElevatedButton.icon(onPressed: ()=>Navigator.pushNamed(context,'/chat'), icon: Icon(Icons.chat), label: Text('چت')),
              ElevatedButton.icon(onPressed: ()=>Navigator.pushNamed(context,'/ocr'), icon: Icon(Icons.photo), label: Text('OCR')),
            ]),
            SizedBox(height:16),
            Expanded(child: ListView(children: [
              ListTile(title: Text('آخرین QCها'), subtitle: Text('هیچ موردی ثبت نشده')),
              ListTile(title: Text('خرابی‌ها'), subtitle: Text('هیچ خرابی ثبت نشده')),
            ]))
          ],
        ),
      ),
    );
  }
}
