// import 'dart:html';

import 'dart:io';

import 'package:apirest/Apod.dart';
import 'package:flutter/material.dart';
import 'package:apirest/ApiService/ApiService.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fetch Data Example",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<Apod>(
        future: apiService.getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHomePage(snapshot: snapshot);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

final ApiService apiService = ApiService();

class MyHomePage extends StatefulWidget {
  final AsyncSnapshot<Apod> snapshot;
  MyHomePage({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  final String? id = prefs.getString('id');
  return id;
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<String?> idUser = getUserId();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(widget.snapshot.data!.url),
                fit: BoxFit.cover,
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Container(
                width: double.infinity,
                height: size.height * 0.75,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.snapshot.data!.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                              onPressed: () => {
                                    apiService.addFav(
                                        widget.snapshot.data!.date,
                                        widget.snapshot.data!.explanation,
                                        widget.snapshot.data!.title,
                                        widget.snapshot.data!.url,
                                        widget.snapshot.data!.copyright)
                                  },
                              icon: Icon(Icons.favorite_outline))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          widget.snapshot.data!.copyright,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(widget.snapshot.data!.date),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(widget.snapshot.data!.explanation),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final uri = Uri.parse(widget.snapshot.data!.url);
          final response = await http.get(uri);
          final bytes = response.bodyBytes;

          Directory temp = await getTemporaryDirectory();
          final path = '${temp.path}/image.jpg';
          File(path).writeAsBytesSync(bytes);

          await Share.shareFiles([path],
              text: widget.snapshot.data!.title +
                  "\n" +
                  widget.snapshot.data!.date);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.share),
      ),
    );
  }
}
