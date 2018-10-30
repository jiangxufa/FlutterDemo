//在Android中，当您执行耗时任务时，通常会显示进度指示器。
//
//在Flutter中，这可以通过渲染Progress Indicator widget来实现。您可以通过编程方式显示Progress Indicator ，
// 通过布尔值通知Flutter在耗时任务发起之前更新其状态。
//
//在下面的例子中，我们将build函数分解为三个不同的函数。如果showLoadingDialog为true（当widgets.length == 0时），
// 那么我们展示ProgressIndicator，否则我们将展示包含所有数据的ListView。

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(DemoLoading());
}

class DemoLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Demo Loading",
      theme: ThemeData(primaryColor: Colors.lightGreen),
      home: DemoLoadingPage(),
    );
  }
}

class DemoLoadingPage extends StatefulWidget {
  @override
  DemoLoadingPageState createState() => DemoLoadingPageState();
}

class DemoLoadingPageState extends State<DemoLoadingPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    String url = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(url);
    setState(() {
      widgets = json.decode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo Loading"),
      ),
      body: getBody(),
    );
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  //当widgets.length == 0时），那么我们展示ProgressIndicator
  showLoadingDialog() {
    if (widgets.length == 0) {
      return true;
    }
    return false;
  }

  ListView getListView() {
    return ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (BuildContext context, int index) {
          return getRow(index);
        });
  }

  Widget getRow(int position) {
    return Container(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("Row ${widgets[position]["title"]}"),
        ),
        Divider(
          color: Colors.red,
        ),
      ],
    ));
  }
}
