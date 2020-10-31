import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../authenticate.dart';
import '../main.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  var _authenticator = new Authenticator();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    // _write(
    //     '{"elements" : [{"title": "John Smith", "content": "john@example.com"},{"title": "mike", "content": "password"}, {"title": "hugh", "content": "password2"}]}');

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
                        hintText: 'Enter your email',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (val) => setState(() => formEntry = val)),
                  // Text(
                  //   failMessage,
                  //   style: TextStyle(
                  //     color: Colors.red,
                  //   ),
                  // ),
                  ElevatedButton(
                      child: Text('Open route'),
                      onPressed: () async {
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          buildList = [];
                          await _authenticator.authenticate(formEntry);
                          String passwords = await _authenticator.passwords;
                          if (await _authenticator.authenticated) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FirstRoute(list: passwords)));
                            // Navigate to second route when tapped.
                            // } else {
                            //   setState(() {
                            //     failMessage = 'incorrect password';
                            //   });
                            // }
                          }
                        }
                      })
                ]))
          ],
        ),
      ),
    );
  }
}
