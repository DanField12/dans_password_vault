import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
  ));
  // MyApp());
}

class FirstRoute extends StatelessWidget {
  FirstRoute({this.list, this.worked});

  final bool worked;
  final List<Widget> list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          children: list,
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
                        hintText: 'Enter your email',
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

class MyApp extends StatelessWidget {
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
  String readText;
  var crypt = AesCrypt('');
  final _formKey = GlobalKey<FormState>();
  bool correctPassword = false;
  String failMessage = '';

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    crypt.setOverwriteMode(AesCryptOwMode.on);
    crypt.encryptTextToFileSync(text, '${directory.path}/testfile.txt.aes',
        utf16: true);
  }

  Future<String> _read() async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      text = crypt.decryptTextFromFileSync('${directory.path}/testfile.txt.aes',
          utf16: true);
      return text;
    } catch (e) {
      print("Couldn't read file");
      return 'bruh';
    }
  }

  List<Widget> buildList;

  void getPasswords() async {
    try {
      // await getPath();
      print('got here!');
      Map<String, dynamic> row = jsonDecode(await _read());
      correctPassword = true;
      for (int i = 0; i < row['elements'].length; i++) {
        print(
            '${row['elements'][i]['title']} : ${row['elements'][i]['content']}');
        buildList.add(
          Container(
            height: 50,
            color: Colors.amber[600],
            child: Center(
                child: Text(
                    '${row['elements'][i]['title']} : ${row['elements'][i]['content']}')),
          ),
        );
      }
    } catch (e) {
      correctPassword = false;
      print(e);
    }
    print(buildList);
  }

  @override
  Widget build(BuildContext context) {
    // _write(
    //     '{"elements" : [{"title": "John Smith", "content": "john@example.com"},{"title": "mike", "content": "password"}, {"title": "hugh", "content": "password2"}]}');

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
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
                        hintText: 'Enter your email',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (val) => setState(() => crypt = AesCrypt(val))),
                  Text(
                    failMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                    child: Text('Open route'),
                    onPressed: () async {
                      final form = _formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        buildList = [];
                        await getPasswords();
                        List<Widget> passwords = buildList;
                        if (correctPassword) {
                          setState(() {
                            failMessage = '';
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FirstRoute(list: passwords)));
                          // Navigate to second route when tapped.
                        } else {
                          setState(() {
                            failMessage = 'incorrect password';
                          });
                        }
                      }
                    },
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}
