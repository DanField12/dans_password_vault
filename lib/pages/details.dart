import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  Details({this.password, this.content, this.pageTitle, this.url});
  final String password;
  final String content;
  final String pageTitle;
  final String url;

  @override
  DetailsPage createState() => DetailsPage(
        password: password,
        content: content,
        url: url,
        pageTitle: pageTitle,
      );
}

class DetailsPage extends State<Details> {
  DetailsPage({this.password, this.content, this.pageTitle, this.url});

  String password;
  String content;
  String pageTitle;
  String url;

  String usernameMessage = "Show";
  bool usernameShown = false;
  Color passwordColour = Color.fromARGB(255, 20, 20, 20);
  String passwordMessage = "Show";
  bool passwordShown = false;
  Color usernameColour = Color.fromARGB(255, 20, 20, 20);

  void showUsername() {
    if (usernameShown) {
      setState(() {
        usernameShown = false;
        usernameMessage = "Show";
        usernameColour = Colors.grey[900];
      });
    } else {
      setState(() {
        usernameShown = true;
        usernameMessage = "Hide";
        usernameColour = null;
      });
    }
  }

  void showPassword() {
    if (passwordShown) {
      setState(() {
        passwordShown = false;
        passwordMessage = "Show";
        passwordColour = Colors.grey[900];
      });
    } else {
      setState(() {
        passwordShown = true;
        passwordMessage = "Hide";
        passwordColour = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(pageTitle),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  pageTitle,
                  textAlign: TextAlign.center,
                  textScaleFactor: 3.5,
                ),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  url,
                  style: TextStyle(color: Color.fromARGB(255, 160, 160, 160)),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.5,
                ),
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Username: ",
                    textScaleFactor: 1,
                  ),
                ),
                Container(
                  color: usernameColour,
                  width: 200,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    content,
                    textScaleFactor: 1,
                    style: TextStyle(color: usernameColour),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      showUsername();
                    },
                    child: Text(usernameMessage))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "password:  ",
                    textScaleFactor: 1,
                  ),
                ),
                Container(
                  color: passwordColour,
                  width: 200,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    password,
                    textScaleFactor: 1,
                    style: TextStyle(color: passwordColour),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      showPassword();
                    },
                    child: Text(passwordMessage))
              ],
            )
          ],
        ));
  }
}
