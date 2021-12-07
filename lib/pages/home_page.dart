import 'package:api1/data/firebase_helper.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
/*
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: new Center(
        child: new Text("Estou logado"),
      )
    );
  }
}*/

class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  String url = "http://localhost:3000/auth/users";
  String token =
      "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2Mzg3OTg0NTB9.unCCYeFw5qJYDtjP7XSjY-6FmX1VOHQ9QgOuE8v9fJ8";
  List<dynamic> data = [];

  Future<String> makeRequest() async {
    var response = await http.get(Uri.parse(url),
        headers: {"Accept": "application/json", "Authorization": token});

    setState(() {
      var extractdata = jsonDecode(response.body);
      data = extractdata;
      print(data);
    });

    return Future.value(response.body);
  }

  @override
  void initState() {
    super.initState();
    FirebaseHelper.listenAuthActions(this.context, false);
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Lista de usuários')),
      body: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            return new ListTile(
                title: new Text(data[i]["title"]),
                subtitle: new Text(data[i]["release_date"]),
                leading: new CircleAvatar(
                  backgroundImage: new NetworkImage(
                      "http://placehold.it/128x128?text=" +
                          data[i]["episode_id"].toString()),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext coontext) =>
                              new SecondPage(data[i])));
                });
          }),
    );
  }
}

class SecondPage extends StatelessWidget {
  SecondPage(this.data);
  final data;
  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(title: new Text(data["title"])),
      body: new Center(
        child: new Container(
          width: 250.0,
          height: 250.0,
          decoration: new BoxDecoration(
            color: const Color(0xff7c94b6),
            // image: new  DecorationImage(
            //   image: new NetworkImage(url),
            //   fit: BoxFit.cover
            // ),
            borderRadius: new BorderRadius.all(new Radius.circular(75.0)),
            border: new Border.all(color: Colors.red, width: 4.0),
          ),
        ),
      ));
}
