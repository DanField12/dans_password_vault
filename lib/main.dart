import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'authenticate.dart';
import 'package:flutter/foundation.dart';
import 'pages/details.dart';
import 'pages/home.dart';

void main() {
  runApp(MaterialApp(
    title: '',
    home: HomePage(),
  ));
  // MyApp());
}

class FirstRoute extends StatelessWidget {
  FirstRoute({this.list});

  String list;

  @override
  Widget build(BuildContext context) {
    List<Widget> buildList() {
      Map<String, dynamic> row = jsonDecode(list);
      List<Widget> buildList = [];
      for (int i = 0; i < row['elements'].length; i++) {
        buildList.add(InkWell(
          onLongPress: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailsPage(
                          content: '${row['elements'][i]['content']}',
                          password: '${row['elements'][i]['password']}',
                        )));
          },
          child: Container(
            height: 50,
            child: Center(child: Text('${row['elements'][i]['websiteURL']}')),
          ),
        ));
      }
      return buildList;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          children: buildList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateEntry()));
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Entry {
  String websiteURL;
  String title;
  String content;
}

class CreateEntry extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  void _showExitDialog(BuildContext context) async {
    // flutter defined function
    BuildContext greaterContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Alert Dialog title"),
          content: Text(
              "Are you sure you want to go back, your entry will NOT be saved?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(greaterContext);
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _entry = Entry();
    return new WillPopScope(
      onWillPop: () async {
        _showExitDialog(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('First Route'),
        ), // This trailing comma makes auto-formatting nicer for build methods.
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText:
                            'Enter the website whose password you want to store',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      // onSaved: (val) => setState(() => crypt = AesCrypt(val))),
                      // onSaved: (val) =>
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter your password for this website',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },

                      // onSaved: (val) =>
                    ),
                    ElevatedButton(
                      child: Text('Open route'),
                      onPressed: () async {
                        final form = _formKey.currentState;
                        if (form.validate()) {}
                      },
                    ),
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
