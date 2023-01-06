import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogBox {
  information(BuildContext context, String title, String description) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                Text(description),
              ],
            )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok")),
            ],
          );
        },
        barrierDismissible: true);
  }
}
