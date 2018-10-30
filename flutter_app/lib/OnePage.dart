import 'dart:isolate';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Custom.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "这是一个sample",
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: OnePage(),
    );
  }
}

class OnePage extends StatefulWidget {
  final String title;

  OnePage({Key key, this.title}) : super(key: key);

  @override
  _OnePageState createState() => _OnePageState(title);
}

class _OnePageState extends State<OnePage> {
  String textToShow = '我就试一下';
  bool toggle = false;
  final String title;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  static dataLoader(SendPort sendPort) async{
    ReceivePort port = new ReceivePort();

    sendPort.send(port.sendPort);

    await for(var msg in port){
      String data = msg[0];
      SendPort replyTo = msg[1];

      String dataUrl = data;
      http.Response response = await http.get(dataUrl);

      replyTo.send(json.decode(response.body));
    }
  }

  loadData() async{
    ReceivePort receivePort = new ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    SendPort sendPort = await receivePort.first;

    List msg = await sendReceive(sendPort, "https://jsonplaceholder.typicode.com/posts");

    setState(() {
      _updateText(text: msg.toString());
    });
  }

  Future sendReceive(SendPort port, msg) {
    ReceivePort response = new ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }

  _OnePageState(this.title);

  void _updateText({String text = '你皮呀'}) {
    setState(() {
      textToShow = text;
    });
  }

  void _toggle() {
    setState(() {
      toggle = !toggle;
    });
  }

  _getToggleChild() {
    if (toggle) {
      return CustomButton('Toggle one');
    } else {
      return MaterialButton(
        onPressed: () {},
        child: CustomButton('Toggle Two'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.list),
              onPressed: () {
                Navigator.of(context).pushNamed('/b');
              }),
        ],
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {},
          child: _getToggleChild(),
          color: Colors.deepPurple,
          padding: new EdgeInsets.only(left: 10.0, right: 10.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggle,
        tooltip: '更新文字',
        child: Icon(Icons.update),
      ),
    );
  }
}
