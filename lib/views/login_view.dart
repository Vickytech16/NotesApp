// 15/03/2024

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
 
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
      title:const  Text("Login screen"),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
        
     ),

    // Body Section Creates a Register Button with two parameters + Two input boxes for username nad password
    // FutureBuider is used to build a future, this future ensures that firebase is initialized before the app starts running

    body:  Column( 

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
          
                  // We declare a try block because when we authenticate the email and password, it will throw an exception if the user is not registered
                  // We have to handle that exception with try catch block
                  try{ 
                             
                  // user Credential is a built in variable, which holds the user information
                  final userCredential = 
                    // This method is used to sign in with our email and password, and return the user credential, similar to what we did in create user method
                    // This is a asynchronous method, so we used await keyword
                    
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email1, // the left side is default parameter from outside function, the right side is our email value
                      password: password1// the left side is default parameter from outside function, the right side is our password value
                      );
          
                    print(userCredential); // print the value to the console

                  }
                  
                 /* As of now, this try catch block has error. The error is even if the user is not found or password is incorrect, 
                  the error message shown is "invalid-credential". Date : 18/03/2024. */

                  // This block will specifically catch only firebaseauth type errors
                  on FirebaseAuthException catch(e)
                  {
                    print(e.code); // This will print the error code.
                    print(e.message); // This will print the actual error message

                    // We have to handle various errors by passing the error message to the switch statement
                    switch(e.code) 
                    {
                      case "invalid-credential":
                        print("The user is not registered"); // If the entered pair is not available
                        break;
                      case "invalid-email":
                        print("The email format is not valid"); // The email id is not in email format
                        break;
                      case "user-not-found":
                        print("The user is not found"); // The user is a new user/not already registered
                        break;
                      case "wrong-password":
                        print("Enter the correct password"); // The entered password is wrong
                        break;
                      default:
                        print("No errors");                     
                    }              
                  }
                  
                  // This is a general catch block which catches all types of exceptions
                  catch(e)
                  {
                  print("Enter valid data"); // Print this on console
                  print(e); // Print the error
                  print(e.runtimeType); // Print the type of error
                  }  

                }, 
                               
                child: const Text("Login")), // Displays the name of the button

                // Create a button to redirect to register view
                TextButton(

                  // We are going to use a navigator method along with our named route
                  onPressed: 
                  ()

                  {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/register/', // Route name
                      (route) => false);
                  },

                  child: const Text("New user?Register here"))

            ], // Children block end
 
          )
          
          );
        }  
      } 
 
    



/*  Edited code

 
FutureBuilder(

      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
        ),  // This will include firebase to our app 

      builder: (context, snapshot) // This builder parameter is a default arguement
      {     

      // The arguement snapshot defines the state of the future. We pass it's value to switch statement  
      switch(snapshot.connectionState)
      {
        case ConnectionState.done: { // This case refers when the Future is loaded succesfully

        /* We are going  to return the entire body part (Registration screen part) to this future function. So this ensures the app
         gets created only when we successfully initialize the future */


*/

