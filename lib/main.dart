// 15/03/2024

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
// ignore: unused_import
import 'package:mynotes/views/login_view.dart';
// ignore: unused_import
import 'package:mynotes/views/register_view.dart';

void main() {
  
  WidgetsFlutterBinding.ensureInitialized(); // This statement ensures that firebase is initialized even before the app is created
  
  runApp(    
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // this defines the default color in BODY of the app
        useMaterial3: true,
      ),
      home: const HomePage(),
    ));
}

// We are creating a homepage widget to help us display a appropriate homepage for user based on their state
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    // We are creating a simple scaffold for user
    return Scaffold(

      // This holds info about the app title bar
    appBar: AppBar(
      title:const  Text("HomePage"),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      ),

      
    body: FutureBuilder(

      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
        ),  // This will include firebase to our app 

      builder: (context, snapshot) // This builder parameter is a default arguement
      {     

      // The arguement snapshot defines the state of the future. We pass it's value to switch statement  
      switch(snapshot.connectionState)
      {
        // This case refers when the Future is loaded succesfully
        case ConnectionState.done: { 

            final user = FirebaseAuth.instance.currentUser; // This will return the details of current user
            print(user);

            /* This is very crucial. The first part returns whether the user email is verified or not(true or false boolean values).
            But the value cannot be determined beforehand, and this value can be null, so we add a nullsafety ?. 
            and incase if the value is null,we cannot access it inside if else structure,so we assign default value as false using ??  */ 
            if (user?.emailVerified ?? false)
              print("The user Email is verified");
            else
              print("Verify your email first!");
                       
            return const Text("Done"); // If the firebase inclsitialization is succesful, this will return this text 
        }

        // This refers to default case of snapshot. This occurs when the future is loading or failed
        default:
         return const  Text("Loading");        
      } 
       }, // Future Builder bloc     
 
      ),

    );
  }
}
