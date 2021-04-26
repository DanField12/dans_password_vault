import 'package:flutter/material.dart';

import '../exit_alert.dart';
import '../json_parse.dart';
import 'details.dart';
import '../main.dart';

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
    });
  }

  List<Widget> buildList() {
    // Map<String, dynamic> row = jsonDecode(list);
    List<Widget> buildList = [];
    if (list != null) {
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
                      child: InkWell(
                        child: Row(children: [Icon(Icons.edit), Text('Edit')]),
                      ),
                    ),
                    PopupMenuItem(
                      child: InkWell(
                        child:
                            Row(children: [Icon(Icons.delete), Text('Delete')]),
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
      return buildList;
    }
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
