import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../authenticate.dart';
import '../json_parse.dart';
import '../main.dart';
import 'home.dart';
import '../loading.dart';
import 'register.dart';

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
                        labelText: 'Email',
                      ),
                      onSaved: (val) => setState(() => emailEntry = val)),
                  TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      onSaved: (val) => setState(() => passwordEntry = val)),
                  Text(
                    failMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: ElevatedButton(
                              child: Text('Login'),
                              onPressed: () async {
                                final form = _formKey.currentState;
                                if (passwordEntry != null ||
                                    emailEntry != null) {
                                  if (form.validate()) {
                                    buildList = [];
                                    form.save();

                                    Dialogs.showLoadingDialog(
                                        context, _keyLoader);
                                    await _authenticator.authenticate(
                                        secretKey: passwordEntry,
                                        emailIdentifier: emailEntry);
                                    await _authenticator.readFile(
                                        secretKey: passwordEntry,
                                        emailIdentifier: emailEntry);
                                    Navigator.of(_keyLoader.currentContext,
                                            rootNavigator: true)
                                        .pop();
                                    if (_authenticator.authenticated) {
                                      EntryList passwordList = new EntryList();
                                      if (_authenticator.passwords != null) {
                                        passwordList.listAsJSON =
                                            _authenticator.passwords;
                                        passwordList.decodeEntries();
                                      }
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyDemo(
                                                    list: passwordList
                                                        .decodedList,
                                                    email: emailEntry,
                                                    secret: passwordEntry,
                                                  )));
                                      // Navigate to second route when tapped.
                                    } else if (passwordEntry != '') {
                                      setState(() {
                                        failMessage =
                                            'Incorrect username or password';
                                      });
                                    }
                                  }
                                }
                              })),
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: ElevatedButton(
                              child: Text('Register'),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              }))
                    ],
                  )
                ]))
          ],
        ),
      ),
    );
  }
}
