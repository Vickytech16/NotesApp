// 25/03/2023

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


// We are creating a widget for Email verification screen
class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // This displays the title of app
      appBar: AppBar(
        title: const Text("Email Verification"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      // Body
      body: Column(
      
        children: [
          const Text("Verify your Email address"), // This will s.how a text asking them to verify their mail address
          TextButton(
          
          // This will dictate what to do once the button is pressed  
          onPressed : 
          () // We use async and await here because the sendEmailverification() method returns a future.
          async {
            final user = FirebaseAuth.instance.currentUser; // This will return the details of current user
            await user?.sendEmailVerification(); // We use null safety here since the Email may not exist, and in that case null is returned
            
          }, 
          
          // This will display the name of the button
          child: const Text("Verify"))
      
        ],),
    );
  }
}




// Temporarily cut off code

/*

Scaffold(
      
// Part 1

     // Appbar for Email Verification view
     appBar:  AppBar(
      title: const Text("Email Verification Screen"),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
     ),

     // Body for Email Verification view
     body: 

 // Part 2


            // This entire code is to push the email verification view screen when the user is not verified. 
            // More insight needed        
            {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EmailVerificationView())
              );        

*/