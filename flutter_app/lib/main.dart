import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'show_code.dart';
import 'dart:convert';

class PictureInfo {
  final String date;
  final String title;
  final String url;
  final String description;

  PictureInfo({this.date, this.title, this.url, this.description});

  factory PictureInfo.fromJson(Map<String, dynamic> json) {
    return PictureInfo(
      date: json['date'],
      title: json['title'],
      url: json['url'],
      description: json['explanation'],
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
  PictureInfo _pictureInfo;

  @override
  void initState() {
    _url = widget.url;
    super.initState();
  } //initState

  _sendRequestGet() {
    //update form data
    http.get(_url).then((response) {
      _pictureInfo = PictureInfo.fromJson(json.decode(response.body));

      setState(() {}); //reBuildWidget
    }).catchError((error) {
      _pictureInfo = PictureInfo(
        date: '',
        title: error.toString(),
        url: '',
        description: '',
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
                    child: Text('See picture of the day'), onPressed: _sendRequestGet),
                SizedBox(height: 20),
                Text(_pictureInfo == null ? '' : _pictureInfo.date,
                    style: TextStyle(fontSize: 15, color: Colors.green)),
                SizedBox(height: 10),
                Text(_pictureInfo == null ? '' : _pictureInfo.url,
                    style: TextStyle(fontSize: 20, color: Colors.blue)),
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
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.code),
                tooltip: 'Code',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CodeScreen()));
                })
          ],
        ),
        body: TestHttp(
            url: 'https://raw.githubusercontent.com/PoojaB26/ParsingJSON-Flutter/master/assets/student.json'));
  }
}

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));