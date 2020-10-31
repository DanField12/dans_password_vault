import 'dart:async';
import 'dart:io';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:path_provider/path_provider.dart';

class Authenticator {
  String passwords;
  bool authenticated = false;

  _write(String secretKey, String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    var crypt = AesCrypt(secretKey);
    crypt.setOverwriteMode(AesCryptOwMode.on);
    crypt.encryptTextToFileSync(text, '${directory.path}/testfile.txt.aes',
        utf16: true);
  }

  Future<void> authenticate(String secretKey) async {
    // await _write(secretKey,
    //     '{"elements": [{"title": "Google","websiteURL": "google.com", "username": "bob", "password": "mypassword1"},{"title": "Steam" ,"websiteURL": "store.steampowered.com", "username": "bob6969", "password": "mypassword2"},{"title" : "Apple","websiteURL": "apple.com", "username": "david12", "password": "mypassword3"}]}');
    await Future.delayed(Duration(seconds: 5), () async {
      passwords = await readFile(secretKey);
    });
    authenticated = (passwords != 'Error');
  }

  Future<String> readFile(String secretKey) async {
    String text;
    try {
      var crypt = AesCrypt(secretKey);
      final Directory directory = await getApplicationDocumentsDirectory();
      text = crypt.decryptTextFromFileSync('${directory.path}/testfile.txt.aes',
          utf16: true);
      print(text);
      return text;
    } catch (e) {
      print("Couldn't read file");
      return 'Error';
    }
  }
}
