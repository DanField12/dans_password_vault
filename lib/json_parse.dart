import 'dart:convert';

import 'package:dans_password_vault/authenticate.dart';

class Entry {
  Entry({this.title, this.password, this.username, this.websiteURL});
  int id;
  String title;
  String websiteURL;
  String username;
  String password;

  Map<String, dynamic> toJson() => {
        'title': title,
        'websiteURL': websiteURL,
        'username': username,
        'password': password,
      };
}

class EntryList {
  String listAsJSON;
  List<Entry> decodedList = [];
  //  list;

  void decodeEntries() {
    Map<String, dynamic> row = jsonDecode(listAsJSON);
    List<Entry> list = [];
    for (int i = 0; i < row['elements'].length; i++) {
      Entry currentEntry = new Entry();
      currentEntry.title = row['elements'][i]['title'];
      currentEntry.websiteURL = row['elements'][i]['websiteURL'];
      currentEntry.username = row['elements'][i]['username'];
      currentEntry.password = row['elements'][i]['password'];
      list.add(currentEntry);
    }
    decodedList = list;
  }

  Future<void> addEntry(String title, String username, String websiteURL,
      String password, String secretKey, String email) async {
    decodedList.add(new Entry(
        title: title,
        username: username,
        websiteURL: websiteURL,
        password: password));
    setEntries(secretKey, email);
  }

  Future<void> setEntries(String secretKey, String email) async {
    listAsJSON = '{"elements": ${jsonEncode(decodedList)}}';
    print(listAsJSON);
    Authenticator _authenticator = new Authenticator();
    await _authenticator.write(secretKey, listAsJSON, email);
  }
}
