// 15/03/2024


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
// ignore: unused_import
import 'package:mynotes/views/register_view.dart';
// ignore: unused_import
import 'package:mynotes/views/email_verification_view.dart';

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

      // A route act as a link between various screens
      /* A route has a map structure, where each key is a string, and each value is an anonymous function, 
      with default arguement "context", and returns a function. */
      routes: {
        '/login/': (context) => const LoginView(), // the route "/login/" acts as a route to loginview screen
        '/register/': (context) => const RegisterView(), // the route "/register/" acts as a route to registerview screen
      },

    ));
}

// We are creating a homepage widget to help us display a appropriate homepage for user based on their state
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    // We are returning the futurebuilder in homepage itself so we need not to do this in every screen
    return FutureBuilder(

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

            // checks whether a user is logged in or not
            if (user!=null)
            {
             if (user.emailVerified)
              return const Text("Success!"); // When user is logged in and has their email verified
             
             else
              return const EmailVerificationView(); // When user is logged in but not email verified
             
            }
            else{
              return const LoginView(); // When no users are logged in
            }
        }
         default:
             return const  Text("Loading");        
        } 
       },   
      );
  }}
