import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'authenticate.dart';
import 'package:flutter/foundation.dart';
import 'json_parse.dart';
import 'loading.dart';
import 'pages/details.dart';
import 'pages/login.dart';
import 'exit_alert.dart';
import 'pages/home.dart';

void main() {
  runApp(MaterialApp(
    title: '',
    home: HomePage(),
  ));
  // MyApp());
}

class Create extends StatefulWidget {
  const Create({this.email, this.secretKey});
  final String email;
  final String secretKey;

  @override
  CreateEntry createState() => CreateEntry(secretKey: secretKey, email: email);
}

class CreateEntry extends State<Create> {
  CreateEntry({this.email, this.secretKey});
  final String email;
  final String secretKey;

  final snackBar = SnackBar(content: Text('New entry added!'));
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  String website;
  String title;
  String username;
  String password;

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
                  child: Expanded(
                      child: Column(children: [
                    TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Website URL',
                        ),
                        onSaved: (val) => setState(() => this.website = val)),
                    TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        onSaved: (val) => setState(() => this.title = val)),
                    TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                        onSaved: (val) => setState(() => this.username = val)),
                    TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        onSaved: (val) => setState(() => this.password = val)),
                    ElevatedButton(
                        child: Text('Open route'),
                        onPressed: () async {
                          if (this.password != null ||
                              this.username != null ||
                              this.title != null ||
                              this.website != null) {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              Dialogs.showLoadingDialog(context, _keyLoader);

                              EntryList passwordList = new EntryList();
                              Authenticator _authenticator =
                                  new Authenticator();

                              print('email ' + email);
                              print('key ' + secretKey);

                              await _authenticator.readFile(
                                  secretKey: secretKey, emailIdentifier: email);
                              if (_authenticator.passwords != null) {
                                passwordList.listAsJSON =
                                    _authenticator.passwords;
                                passwordList.decodeEntries();
                              }
                              print(_authenticator.passwords);

                              await passwordList.addEntry(
                                  this.title,
                                  this.username,
                                  this.website,
                                  this.password,
                                  secretKey,
                                  email);
                              print("got here!");
                              Navigator.of(_keyLoader.currentContext,
                                      rootNavigator: true)
                                  .pop();
                              Navigator.popUntil(
                                  context, (Route<dynamic> route) => false);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyDemo(
                                          secret: secretKey,
                                          email: email,
                                          list: passwordList.decodedList)));
                            }
                          }
                        }),
                  ])))
            ],
          ),
        ),
      ),
    );
  }
}
