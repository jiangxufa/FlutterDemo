


import 'package:flutter/material.dart';
import 'package:flutter_app/OnePage.dart';
//页面跳转
void main(){
  runApp(MaterialApp(
    home: OnePage(title: 'Home',),
    routes: <String,WidgetBuilder>{
      '/a':(BuildContext context)=>OnePage(title: 'A',),
      '/b':(BuildContext context)=>OnePage(title: 'B',),
      '/c':(BuildContext context)=>OnePage(title: 'C',),
    },
  ));
}