import 'dart:async';
import 'dart:io';
import 'package:aes_crypt/aes_crypt.dart';
import 'package:path_provider/path_provider.dart';

class Authenticator {
  String passwords;
  bool authenticated = false;

  Future<String> initNewUser(String secretKey, String emailIdentifier) async {
    await Future.delayed(Duration(seconds: 5), () async {
      final Directory directory = await getApplicationDocumentsDirectory();
      var crypt = AesCrypt(secretKey);
      print('encrypted');

      try {
        crypt.encryptTextToFileSync('Authenticated',
            directory.path + '/' + emailIdentifier + 'auth.txt.aes',
            utf16: true);
        return secretKey;
      } catch (e) {
        print("didn't work");
        return 'dirExists';
      }
    });
  }

  Future<void> write(
      String secretKey, String text, String emailIdentifier) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    var crypt = AesCrypt(secretKey);
    print('encrypted');
    crypt.setOverwriteMode(AesCryptOwMode.on);
    crypt.encryptTextToFileSync(
        text, directory.path + '/' + emailIdentifier + '.txt.aes',
        utf16: true);
  }

  Future<void> authenticate({
    String secretKey,
    String emailIdentifier,
  }) async {
    await Future.delayed(Duration(seconds: 5), () async {
      String text;
      print('got here');
      try {
        var crypt = AesCrypt(secretKey);
        final Directory directory = await getApplicationDocumentsDirectory();

        text = crypt.decryptTextFromFileSync(
            directory.path + '/' + emailIdentifier + 'auth.txt.aes',
            utf16: true);
        print(text);
      } catch (e) {
        print(e);
      }
      // return (text == 'authenticated');

      // await Future.delayed(Duration(seconds: 5), () async {
      //   passwords = await readFile(secretKey);
      // });
      authenticated = (text == 'Authenticated');
    });
  }

  Future<void> readFile({String secretKey, String emailIdentifier}) async {
    String text;
    try {
      var crypt = AesCrypt(secretKey);
      final Directory directory = await getApplicationDocumentsDirectory();
      text = crypt.decryptTextFromFileSync(
          directory.path + '/' + emailIdentifier + '.txt.aes',
          utf16: true);
      print(text);
      passwords = text;
    } catch (e) {
      print("Couldn't read file");
    }
  }
}
