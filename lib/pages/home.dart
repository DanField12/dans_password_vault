// import 'dart:html';

import 'package:MyVault/pages/online_help.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import '../exit_alert.dart';
import '../json_parse.dart';
import 'details.dart';
import '../main.dart';
import './online_help.dart';

class MyDemo extends StatefulWidget {
  MyDemo({this.list, this.email, this.secret});
  final String email;
  final String secret;
  final List<Entry> list;

  @override
  FirstRoute createState() =>
      FirstRoute(email: email, secretKey: secret, list: list);
}

class FirstRoute extends State<MyDemo> {
  FirstRoute({this.email, this.secretKey, this.list});
  final String email;
  final String secretKey;
  final List<Entry> list;

  @override
  Future<void> delete(int id) async {
    await ExitDialogue.showConfirm(
        context, 'Are you sure you want to delete this.', () {
      var myList = new EntryList();
      setState(() {
        list.removeAt(id);
        print('deleted');
      });
      myList.decodedList = list;
      myList.setEntries(secretKey, email);
      buildList();
    });
  }

  // Future<Widget> getImage(url) async {
  //   try {
  //     await rootBundle.load('assets/icons/' + url + '.ico');
  //   } on Exception {
  //     //   catch (e) {

  //   }
  // }
  // getImage(list[i].websiteURL),

  List<Widget> buildList() {
    // Map<String, dynamic> row = jsonDecode(list);
    List<Widget> buildList = [];
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        buildList.add(InkWell(
          child: ListTile(
              leading: FutureBuilder(
                future: rootBundle
                    .load('assets/icons/' + list[i].websiteURL + '.ico'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image(
                      image: AssetImage(
                        'assets/icons/' + list[i].websiteURL + '.ico',
                      ),
                      height: 40,
                      width: 40,
                    );
                  } else {
                    return Image(
                      image: AssetImage(
                        'assets/icons/default.png',
                      ),
                      height: 40,
                      width: 40,
                    );
                  }
                },
              ),
              title: Text(list[i].title),
              subtitle: Text(list[i].websiteURL),
              trailing: PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: InkWell(
                        child: Row(children: [Icon(Icons.edit), Text(' Edit')]),
                      ),
                    ),
                    PopupMenuItem(
                      child: InkWell(
                        child: Row(
                            children: [Icon(Icons.delete), Text(' Delete')]),
                        onTap: () {
                          delete(i);
                        },
                      ),
                    ),
                  ];
                },
                icon: Icon(Icons.more_vert),
              )),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Details(
                          pageTitle: '${list[i].title}',
                          content: '${list[i].username}',
                          password: '${list[i].password}',
                          url: '${list[i].websiteURL}',
                        )));
          },
          // child: Container(
          //   height: 50,
          //   child: Center(child: Text('${row['elements'][i]['websiteURL']}')),
          // ),
        ));
      }
    }
    if (buildList.isEmpty) {
      buildList = [
        Text(
          "Press the '+' button to add new entries to your password storage.",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
          textScaleFactor: 1.2,
        )
      ];
    }
    print(buildList);
    return buildList;
  }

  Widget build(BuildContext context) {
    print('key' + secretKey);
    print(list);

    return new WillPopScope(
      onWillPop: () async {
        ExitDialogue.showConfirm(
            context, 'Are you sure you want to log out.', () {});
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: InkWell(
                      child: Row(children: [
                        Icon(
                          Icons.help,
                          color: Colors.grey[600],
                        ),
                        Text(' Help')
                      ]),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Help(
                                    s: "Welcome to MyVault. Feel free to start adding new passwords to your storage by pressing the '+' button in the bottom right. You will be redirected to a new page where you can enter the url, the website name (which is just what you want it to be shown as) and your username and password for it.")));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: InkWell(
                      child: Row(children: [
                        Icon(Icons.add_to_drive, color: Colors.grey[600]),
                        Text(' Export to Drive')
                      ]),
                      onTap: () {
                        // delete(i);
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: InkWell(
                      child: Row(children: [
                        Icon(Icons.info, color: Colors.grey[600]),
                        Text(' Info for Nerds')
                      ]),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Help(
                                    s: "My Vault is encrypted using the AES (Advanced Encryption Standard) encryption standard. AES was made by Vincent Rijmen and Joan Daemen. AES uses a 128-bit cipher key. There are 14 rounds and different operations that it does to encrypt your data and keep it safe.")));
                      },
                    ),
                  ),
                ];
              },
            )
          ],
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
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Create(email: email, secretKey: secretKey)));
          },
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
