// 25/03/2023

import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_services.dart';


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
          const Text("We have sent you a verification email. Check your mail and verify your account"), // This will show a text letting users know they recieved a verification mail
          const Text("Haven't got a mail? Click below to send again"), // If the user didn't get one, this will allow them to recieve another mail
          TextButton(
          
          // This will dictate what to do once the button is pressed  
          onPressed : 
          () 
          async {
            await AuthServices.firebase().sendEmailVerification(); // Sends the verification email to the user
            
          }, 
          
          // This will display the name of the button
          child: const Text("Send Again")
          ),

          const Text("Already verified? click the button below"),
          
          // Create a button that allows user to logout from this screen if they accidentally logged in with a unowned email
          TextButton(onPressed: 
          ()
          async {
                  await AuthServices.firebase().logout(); // This will logout the client from the firebase
                  Navigator.of(context).pushNamedAndRemoveUntil("/login/",
                  (route) => false); // This will redirect the logged out used to the login screen
          }, 
          child: const Text("Restart"))
      

        ],),
    );
  }
}


