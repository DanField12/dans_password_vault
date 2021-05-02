import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  Help({this.s});

  final String s;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Help'),
      ),
      body: Center(
          child: Container(
        padding: EdgeInsets.all(20),
        child: Text(s),
      )),
    );
  }
}
