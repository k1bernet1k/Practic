import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'show_code.dart';
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String score;

  User({this.id, this.name, this.score});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        score: json['score'].toString(),
    );
  }
}

class TestHttp extends StatefulWidget {
  final String url;

  TestHttp({String url}) : url = url;

  @override
  State<StatefulWidget> createState() => TestHttpState();
} // TestHttp

class TestHttpState extends State<TestHttp> {
  String _url;
  User _user;



  @override
  void initState() {
    _url = widget.url;
    super.initState();
  } //initState

  _sendRequestGet() {
    //update form data
    http.get(_url).then((response) {
      _user = User.fromJson(json.decode(response.body));

      setState(() {}); //reBuildWidget
    }).catchError((error) {
      _user = User(
        id: '',
        name: '',
        score: '',
      );

      setState(() {}); //reBuildWidget
    });
  } //_sendRequestGet

  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                RaisedButton(
                    child: Text('Узнать победителя'), onPressed: _sendRequestGet),
                SizedBox(height: 20),
                Text('id', style: TextStyle(fontSize: 20.0,color: Colors.green)),
                Text(_user == null ? '' : _user.id,
                   style: TextStyle(fontSize: 15, color: Colors.green)),
                SizedBox(height: 20),
                Text('Имя:', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
                Text(_user == null ? '' : _user.name,
                    style: TextStyle(fontSize: 20, color: Colors.blue)),
                SizedBox(height: 20),
                Text('Количество очков:', style: TextStyle(fontSize: 20.0,color: Colors.red)),
                Text(_user == null ? '' : _user.score.toString(),
                    style: TextStyle(fontSize: 25, color: Colors.red)),
              ],
            )));
  } //build
} //TestHttpState
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test HTTP API'),
          actions: <Widget>[IconButton(icon: Icon(Icons.code), tooltip: 'Code', onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CodeScreen()));
          })],
        ),
        body: TestHttp(url: 'https://raw.githubusercontent.com/PoojaB26/ParsingJSON-Flutter/master/assets/student.json')
    );
  }
}

void main() => runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp()
    )
);


