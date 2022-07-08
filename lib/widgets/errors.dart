import 'package:flutter/material.dart';


Widget buildError(BuildContext context, String title, Map<String, dynamic> errors) {
  return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: errors.entries.map((entry) => Text("${entry.key}: ${entry.value}")).toList()
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
    }


// Future<void> _showErrorDialog(BuildContext context, String title, Map<String, dynamic> errors) {
    
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return buildError(context, title, errors);
//         }
//     );
//   }