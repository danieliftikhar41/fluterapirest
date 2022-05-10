import 'package:apirest/ApodList.dart';
import 'package:apirest/detailsSceen.dart';
import 'package:flutter/material.dart';
import 'package:apirest/ApiService/ApiService.dart';
import 'package:http/http.dart' as http;

final ApiService apiService = ApiService();

class ListSceen extends StatelessWidget {
  const ListSceen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fetch Data Example",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<List<ApodList>>(
        future: apiService.getListData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyListPage(snapshot: snapshot);
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

class MyListPage extends StatefulWidget {
  AsyncSnapshot<List<ApodList>> snapshot;
  MyListPage({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.snapshot.data!.length,
      itemBuilder: (_, index) => Container(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    DetailsScreen(data: widget.snapshot.data![index])));
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                image: DecorationImage(
                  image: NetworkImage(widget.snapshot.data![index].url),
                  fit: BoxFit.cover,
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.snapshot.data![index].title}",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
                SizedBox(height: 10),
                Text("${widget.snapshot.data![index].date}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        decoration: TextDecoration.none)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
