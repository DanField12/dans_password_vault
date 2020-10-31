import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'authenticate.dart';
import 'package:flutter/foundation.dart';
import 'json_parse.dart';
import 'pages/details.dart';
import 'pages/home.dart';
import 'exit_alert.dart';

void main() {
  runApp(MaterialApp(
    title: '',
    home: HomePage(),
  ));
  // MyApp());
}

class FirstRoute extends StatelessWidget {
  FirstRoute({this.list});

  List<Entry> list;

  @override
  Widget build(BuildContext context) {
    List<Widget> buildList() {
      // Map<String, dynamic> row = jsonDecode(list);
      List<Widget> buildList = [];
      for (int i = 0; i < list.length; i++) {
        buildList.add(InkWell(
          child: ListTile(
              leading: Image.network(
                'https://${list[i].websiteURL}/favicon.ico',
                height: 32,
                width: 32,
              ),
              title: Text('${list[i].title}'),
              subtitle: Text('${list[i].websiteURL}'),
              trailing: PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Text('edit'),
                    )
                  ];
                },
                icon: Icon(Icons.more_vert),
              )),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailsPage(
                          pageTitle: '${list[i].title}',
                          content: '${list[i].username}',
                          password: '${list[i].password}',
                        )));
          },
          // child: Container(
          //   height: 50,
          //   child: Center(child: Text('${row['elements'][i]['websiteURL']}')),
          // ),
        ));
      }
      return buildList;
    }

    return new WillPopScope(
      onWillPop: () async {
        ExitDialogue.showExitDialog(
            context, 'Are you sure you want to log out.');
        return false;
      },
      child: Scaffold(
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateEntry()));
          },
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class CreateEntry extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        ExitDialogue.showExitDialog(context,
            'Are you sure you want to go back, your entry will NOT be saved.');
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
                        hintText: 'Enter the website',
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
                        // final form = _formKey.currentState;
                        // if (form.validate()) {}
                        var _authenticator = new Authenticator();
                        await _authenticator.authenticate('a');
                        EntryList passwordList = new EntryList();
                        passwordList.listAsJSON = _authenticator.passwords;
                        passwordList.decodeEntries();
                        print(_authenticator.passwords);
                        await passwordList.addEntry(
                            'hi', 'hi', 'hi', 'hi', 'a');
                        Navigator.popUntil(
                            context, (Route<dynamic> route) => false);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FirstRoute(
                                    list: passwordList.decodedList)));
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
