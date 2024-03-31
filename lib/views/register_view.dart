// 19/03/2024

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "dart:developer" as devtools show log; 

// Creates a stateful widget for stateful widget
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
 
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  // Declaring a TextEditing controller that is used to get values from text box and store it
  late TextEditingController _email; // Fetch Email value
  late TextEditingController _password; // Fetch password value

  // Initializing the Initstate function, which is used to actually initialize the function (assign values to email and password)
  @override
  void initState() {

    _email=TextEditingController();
    _password=TextEditingController();

    super.initState();
  }

  // We created this texteditingcontroller, it is our responsibility to get rid of it from the memory after our use, for that we are using this method
  @override
  void dispose() {
    
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(

    // AppBar defines the topmost app screen where the heading of the app is displayed
    appBar: AppBar( 
      title:const  Text("Registration screen"),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
        
     ),

    // Body Section Creates a Register Button with two parameters + Two input boxes for username nad password
    // FutureBuider is used to build a future, this future ensures that firebase is initialized before the app starts running

    body: Column( 

          children: [   
              // Textbox to enter username
              TextField(
                controller: _email, // The value entered in this box is stored in _email texteditingcontroller
          
                decoration:const InputDecoration(
                  hintText: "Enter your Email",
                ), // This field acts as a placeholder text
          
                keyboardType: TextInputType.emailAddress, // This ensures the email address format, by ensuring @ symbol and . symbol in entered value
                autocorrect: false, // Disables autocorrect for email address
              ), 
          
              // Textbox to enter password
              TextField(
                controller: _password, // The value entered in this box is stored in _password texteditingcontroller
          
                decoration:const InputDecoration(
                  hintText: "Enter your password",
                ), // This field acts as a placeholder text
          
                obscureText: true, // This hides the password field characters into dots
                enableSuggestions: false, // Disable suggestions while typing
                autocorrect: false, // disables autocorrect
              ), 
          
          
              // Creates the Register Button
              TextButton(
          
                onPressed: () // Tells what to do once the button is clicked
              
                // Body of onpressed(), we make it as a async function since we used await inside the block. and this registration is an asynchronous operation.              
                async {
              
                  final email1=_email.text; // Get the text value of email box and store it on email1
                  final password1=_password.text; // Get the text value of password box and store it on password1
          
                  // We write this code inside try catch block to catch run time errors
                  try {

                  // user Credential is a built in variable, which holds the user information

                  final userCredential = 
                    /* This is a built in method which create new user with email and password values and return a future, so we used await keyword to 
                       capture the future on usercredential variable and print it */
          
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email1, // the left side is default parameter from outside function, the right side is our email value
                      password: password1// the left side is default parameter from outside function, the right side is our password value
                      );
          
                    devtools.log(userCredential.toString()); // print the value to the console

                  } 
                 
                  
                  // This will catch all methods that are of type firebaseauth, like account already exists error
                  on FirebaseAuthException catch(e)
                  {
                   devtools.log(e.code);

                   switch(e.code)
                   {
                    case "weak-password":
                      devtools.log("Password must be atleast 6 characters long"); // Weak password
                      break;
                    case "invalid-email":
                      devtools.log("The email format is not valid"); // The format is wrong
                      break;
                    case "email-already-in-use":
                      devtools.log("The email is already in use"); // The email is already used by another user
                      break;                                    
                   }
                  }

                   
                }, 
                               
                child: const Text("Register")), // Displays the name of the button

                // This buttpn helps existing users to go to login screen
                TextButton(onPressed: 

                // We are going to use a navigator method along with our named route
                ()
                {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login/', // Route name
                  (route) => false);
                }, 

                child: const Text("Existing user? login here"))
           
            ], // End of children block
 
          )

      );
  }
}



