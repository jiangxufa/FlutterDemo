import 'package:flutter/material.dart';
//自定义控件
class CustomButton extends StatelessWidget{

  final String lable;

  CustomButton(this.lable);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(onPressed: (){},child: Text(lable),);
  }

}