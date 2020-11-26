import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../authenticate.dart';
import '../json_parse.dart';
import '../main.dart';
import 'home.dart';
import '../loading.dart';
import 'register.dart';

class RegisterPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _RegisterPage(title: 'MyVault Login'),
    );
  }
}

class _RegisterPage extends StatefulWidget {
  _RegisterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<_RegisterPage> {
  List<Widget> buildList;
  String passwordEntry = '';
  String emailEntry = '';
  String failMessage = '';
  var _authenticator = new Authenticator();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            failMessage = 'Please enter your Email';
                          });
                        }
                      },
                      onSaved: (val) => setState(() => emailEntry = val)),
                  TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter your password',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            failMessage = 'Please enter your password';
                          });
                        }
                      },
                      onSaved: (val) => setState(() => passwordEntry = val)),
                  Text(
                    failMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                      child: Text('Create'),
                      onPressed: () async {
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          buildList = [];
                          form.save();

                          Dialogs.showLoadingDialog(context, _keyLoader);
                          await _authenticator.initNewUser(
                              passwordEntry, emailEntry);
                          Navigator.of(_keyLoader.currentContext,
                                  rootNavigator: true)
                              .pop();
                          EntryList passwordList = new EntryList();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyDemo(
                                        list: passwordList.decodedList,
                                        email: emailEntry,
                                        secret: passwordEntry,
                                      )));
                          // Navigate to second route when tapped.
                        } else if (passwordEntry != '') {
                          setState(() {
                            failMessage = 'Incorrect password';
                          });
                        }
                        passwordEntry = '';
                      }),
                ]))
          ],
        ),
      ),
    );
  }
}
