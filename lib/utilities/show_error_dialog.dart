// 03/04/2024


import 'package:flutter/material.dart';

// This method will show users the error message on login screen
Future<void> showErrorDialog(BuildContext context, String text)
{
  return showDialog(context: context, builder: (context) // We are returning a showdialog method which contains a alertdialog
  {

    // This contains the actual alert details
    return AlertDialog(
      title: const Text("An error occured"), // Title of alert message
      content:  Text(text), // content of alert message

      actions: // We are going to create one text button which does nothing and just return the user to login screen
      [
       TextButton(
        onPressed:() 
          {Navigator.of(context).pop();}, // This does nothing, just return the user to the screen
        child: const Text("Ok")
       )
      ],

    );
   },
 );// Showdialog

}// Errordialog