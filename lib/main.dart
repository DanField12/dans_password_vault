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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// class PasswordRegistryElement {
//   final String title;
//   final String content;

//   PasswordRegistryElement(this.title, this.content});

//   factory PasswordRegistryElement.fromJson(Map<String, dynamic> json) {
//     return PasswordRegistryElement(
//       title: json['title'] as String,
//       content: json['content'] as String,
//     );
//   }
// }

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  String readText;
  void getPath() async {
    await _read().then((String result) {
      if (readText == null && result != 'bruh') {
        setState(() {
          readText = result;
        });
      }
    });
  }

  var crypt = AesCrypt('my cool passwor');

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
  // Future<File> get _localFile async {
  //   final path = await _localPath;

  //   return new File('$path/testfile.txt.aes');
  // }

  // void init() async {
  //   final file = await _localFile;
  //   // Write the file.
  //   file.writeAsString('');
  // }

  // // // String _debug1;
  // // // String _debug2;

  // String test() {
  //   init();
  //   var crypt = AesCrypt('my cool password');
  //   String encFilepath = '';
  //   String srcText = 'some text';
  //   String decText = '';
  //   // encFilepath = crypt.encryptTextToFileSync(srcText, _localFile, utf16: true);
  //   decText = crypt.decryptTextFromFileSync(encFilepath, utf16: true);
  //   return encFilepath;
  // }

  @override
  Widget build(BuildContext context) {
    try {
      // _write(
      //     '{"elements" : [{"title": "John Smith", "content": "john@example.com"},{"title": "mike", "content": "password"}]}');
      getPath();
      Map<String, dynamic> row = jsonDecode(readText);
      for (int i = 0; i < row['elements'].length; i++) {
        print('${row['elements'][i]['title']}');
        print('${row['elements'][i]['content']}');
      }
    } catch (e) {
      print(e);
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(test()),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
