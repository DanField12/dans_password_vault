import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({this.password, this.content});

  String password;
  String content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pog'),
      ),
      body: Center(
        child: Text(content + ': ' + password),
      ),
    );
  }
}
