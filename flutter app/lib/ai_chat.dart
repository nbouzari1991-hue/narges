import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIChatScreen extends StatefulWidget {
  @override
  _AIChatScreenState createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final _controller = TextEditingController();
  List<Map<String, String>> messages = [{'who':'bot','text':'ربات: سلام! چطور کمکتون کنم؟'}];

  void sendMessage(String text) async {
    setState(() => messages.add({'who':'user','text':text}));
    try {
      final res = await http.post(Uri.parse('http://10.0.2.2:8000/chat/'), headers: {'Content-Type':'application/json'}, body: json.encode({'message': text}));
      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        setState(() => messages.add({'who':'bot','text': body['reply'] ?? 'بدون پاسخ'}));
      } else {
        setState(() => messages.add({'who':'bot','text':'خطا در ارتباط با سرور'}));
      }
    } catch (e) {
      setState(() => messages.add({'who':'bot','text':'خطا: $e'}));
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('چت با ربات')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (ctx, i) {
                final m = messages[i];
                return ListTile(
                  title: Align(
                    alignment: m['who']=='user'? Alignment.centerRight: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: m['who']=='user'? Colors.blue[50]: Colors.grey[200],
                      child: Text(m['text'] ?? ''),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller)),
                IconButton(icon: Icon(Icons.send), onPressed: () => sendMessage(_controller.text)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
