import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({this.password, this.content, this.pageTitle, this.url});

  String password;
  String content;
  String pageTitle;
  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(pageTitle),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          padding: EdgeInsets.all(8),
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Image.network(
                'https://' + url + '/favicon.ico',
                height: 32,
                width: 32,
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Text(
                pageTitle,
                textScaleFactor: 4,
              ),
            )
          ],
        ));
  }
}
