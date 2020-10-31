import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({this.password, this.content, this.pageTitle});

  String password;
  String content;
  String pageTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: Center(
        child: Text(content + ': ' + password),
      ),
    );
  }
}
