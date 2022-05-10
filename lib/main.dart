// import 'dart:html';
// import 'dart:js';

import 'dart:convert';

import 'package:apirest/bottomMenu.dart';
import 'package:flutter/material.dart';
import 'package:apirest/ApiService/ApiService.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final ApiService apiService = ApiService();
void main() async {
  final prefs = await SharedPreferences.getInstance();
  final bool? login = prefs.getBool('login');
  print(login);
  runApp(MaterialApp(
      title: 'Nasa',
      home: ((login != null && login == true) ? bottomNav() : const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nasa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Nasa'),
    );
  }
}

void Valid(String email, String password, BuildContext context) async {
  var valid = await apiService.login(email, password);
  if (valid) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => bottomNav()));
  } else {
    print("login ko");
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String emailValue = "";
  String passValue = "";
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/imatge/background_wall.jpg"),
        fit: BoxFit.cover,
      )),
      child: Column(
        children: [
          Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Image(
                  image: AssetImage("assets/imatge/logo.png"),
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),
          Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 40.0, horizontal: 30.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 30.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Email'),
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return "Email is requird";
                                }
                              },
                              onSaved: (value) {
                                emailValue = value.toString();
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Password'),
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return "Password is requird";
                                }
                              },
                              onSaved: (value) {
                                passValue = value.toString();
                              },
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Processing Data')),
                                  );
                                  Valid(emailValue, passValue, context);
                                }
                              },
                            )
                          ],
                        )),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
