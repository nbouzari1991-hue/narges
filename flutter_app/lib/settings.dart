import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تنظیمات')),
      body: ListView(children: [
        ListTile(title: Text('آدرس سرور'), subtitle: Text('http://10.0.2.2:8000')),
        ListTile(title: Text('نسخه اپ'), subtitle: Text('0.1.0')),
        ListTile(title: Text('خروج'), onTap: ()=>Navigator.pushReplacementNamed(context, '/')),
      ],),
    );
  }
}
