import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GenderChecker(),
      debugShowCheckedModeBanner: false, // Menonaktifkan banner debug
    );
  }
}

class GenderChecker extends StatefulWidget {
  @override
  _GenderCheckerState createState() => _GenderCheckerState();
}

class _GenderCheckerState extends State<GenderChecker> {
  TextEditingController _controller = TextEditingController();
  String _gender = '';

  Future<void> _checkGender(String name) async {
    final response = await http.get(Uri.parse('https://api.genderize.io/?name=$name'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _gender = data['gender'] != null ? 'Gender: ${data['gender']}' : 'Gender: Unknown';
      });
    } else {
      setState(() {
        _gender = 'Failed to fetch gender';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF56E9F1),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Check the Gender of a Name',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'first or full name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _checkGender(_controller.text);
                      },
                      child: Icon(Icons.search),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  _gender,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
