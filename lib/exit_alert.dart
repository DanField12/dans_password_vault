import 'package:flutter/material.dart';

class ExitDialogue {
  static void showConfirm(
      BuildContext context, String exitMessage, Function onConfirm) {
    BuildContext greaterContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Warning"),
          content: Text(exitMessage),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(greaterContext);
                onConfirm();
              },
            ),
            ElevatedButton(
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
}
