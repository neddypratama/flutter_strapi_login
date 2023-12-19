import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_strapi_login/response_login/response_login.dart';
import 'package:http/http.dart' as http;

Future<ResponseLogin> createLoginResponse(
    String identifier, String password) async {
  final response =
      await http.post(Uri.parse('http://10.0.2.2:1337/api/auth/local'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            <String, String>{
              'identifier': identifier,
              'password': password,
            },
          ));

  if (response.statusCode == 200) {
    return ResponseLogin.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Login.');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<ResponseLogin>? _loginResponse;
  final TextEditingController _identifierController =
      TextEditingController(text: "admin");
  final TextEditingController _passwordController =
      TextEditingController(text: "12345678");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FutureBuilder<ResponseLogin>(
                future: _loginResponse,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasData) {
                    return Text(snapshot.data!.jwt.toString());
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const SizedBox();
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Identifier',
                ),
                controller: _identifierController,
              ),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _loginResponse = createLoginResponse(
                          _identifierController.text, _passwordController.text);
                    });
                  },
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
