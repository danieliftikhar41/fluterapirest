// import 'dart:html';

import 'dart:io';

import 'package:apirest/Apod.dart';
import 'package:apirest/ApodList.dart';
import 'package:flutter/material.dart';
import 'package:apirest/ApiService/ApiService.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class DetailsScreen extends StatelessWidget {
  ApodList data;
  DetailsScreen({Key? key, required this.data}) : super(key: key);

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
            return MyHomePage(data: data);
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
  ApodList data;
  MyHomePage({Key? key, required this.data}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                image: NetworkImage(widget.data.url),
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
                      Text(
                        widget.data.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          widget.data.copyright,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(widget.data.date),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(widget.data.explanation),
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
          final uri = Uri.parse(widget.data.url);
          final response = await http.get(uri);
          final bytes = response.bodyBytes;

          Directory temp = await getTemporaryDirectory();
          final path = '${temp.path}/image.jpg';
          File(path).writeAsBytesSync(bytes);

          await Share.shareFiles([path],
              text: widget.data.title + "\n" + widget.data.date);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.share),
      ),
    );
  }
}
