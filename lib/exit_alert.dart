import 'package:flutter/material.dart';

class ExitDialogue {
  // static String pog = 'hi';
  static void showExitDialog(BuildContext context, String exitMessage) async {
    // flutter defined function
    BuildContext greaterContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Alert Dialog title"),
          content: Text(exitMessage),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(greaterContext);
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
