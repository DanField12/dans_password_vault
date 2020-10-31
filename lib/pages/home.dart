import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../authenticate.dart';
import '../main.dart';
import '../loading.dart';

class HomePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'MyVault Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> buildList;
  String formEntry;
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
                      onSaved: (val) => setState(() => formEntry = val)),
                  Text(
                    failMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                      child: Text('Login'),
                      onPressed: () async {
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          buildList = [];
                          print(formEntry);
                          Dialogs.showLoadingDialog(context, _keyLoader);
                          await _authenticator.authenticate(formEntry);
                          Navigator.of(_keyLoader.currentContext,
                                  rootNavigator: true)
                              .pop();
                          if (_authenticator.authenticated) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FirstRoute(
                                        list: _authenticator.passwords)));
                            // Navigate to second route when tapped.
                          } else if (formEntry != '') {
                            setState(() {
                              failMessage = 'Incorrect password';
                            });
                          }
                          formEntry = '';
                        }
                      })
                ]))
          ],
        ),
      ),
    );
  }
}
