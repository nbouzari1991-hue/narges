import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';

  void login() async {
    await _storage.write(key: 'user', value: username);
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ورود')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(decoration: InputDecoration(labelText: 'نام کاربری'), onChanged: (v)=>username=v),
              TextFormField(decoration: InputDecoration(labelText: 'رمز عبور'), obscureText: true, onChanged: (v)=>password=v),
              SizedBox(height:12),
              ElevatedButton(onPressed: login, child: Text('ورود'))
            ],
          ),
        ),
      ),
    );
  }
}
