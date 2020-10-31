import 'dart:convert';

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

  void addEntry(
      String title, String username, String websiteURL, String password) {
    decodedList.add(new Entry(
        title: title,
        username: username,
        websiteURL: websiteURL,
        password: password));
    listAsJSON = '{"elements": ${jsonEncode(decodedList)}}';
    print(listAsJSON);
  }
}
