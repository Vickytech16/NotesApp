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
import "dart:developer" as devtools show log; // we only gonna use the log method, and devtools is an alias

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
        '/notes/':(context) => const NotesView() // route for Notesview
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
            devtools.log(user.toString());

            // checks whether a user is logged in or not
            if (user!=null)
            {
             if (user.emailVerified)
              {return const NotesView();} // When user is logged in and has their email verified
             
             else
              {return const EmailVerificationView();} // When user is logged in but not email verified
             
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

// We are creating a Enumeration to display a button in our appbar which has options like logout
enum MenuAction {
  logout
}

// We are creating a simple view page to be displayed for users who are logged in and have their email verified
class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // Appbar for our NotesView
      appBar: AppBar(
        title: const Text("Main UI"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,

        // This actions is a parameter which holds the list of buttons and functions to be implemented in the appbar
        actions: [
         // We are creatng a popupmenu button with type as the enum we created, MenuAction. This has two parameters, onselected and itembuilder
         PopupMenuButton<MenuAction>(

          // This methodd will say what to do once the button is clicked
          onSelected: (value) async{

            // We are creating a switch case to direct the logout button to the warning screen, and enabling signout
            switch(value)
            {             
              case MenuAction.logout: // On clicking the logout button
                final onlogout=await showLogOutDialog(context); // The onlogout variable will call the warning method and hold the returned boolea value
                devtools.log(onlogout.toString());

                // This block is to actually allow the user to logout from firebase once they click the logout button
                if(onlogout)
                {
                 await FirebaseAuth.instance.signOut(); // This will logout the client from the firebase
                 Navigator.of(context).pushNamedAndRemoveUntil("/login/",
                 (route) => false); // This will redirect the logged out used to the login screen
                }
            }

         },

          // This is a mandatory that defines the popupmenu Items to be included in the popupmenu Button
          itemBuilder: (context) {
            // This method expects a return value of type list, which has all the popupMenu items to be displayed in popupMenu Button
            return const [
              // We are creating a popupMenu Item of type Menuaction
              PopupMenuItem<MenuAction> (
                value: MenuAction.logout, // This specifies the value the popupMenu item takes. This value is passed to the onselected method.
                child: Text("Logout"), // This specifies the name of the popupMenu item
                ) ];
          }  // End of itemBuilder method     
         )

        ], // End of actions block
      ),

      body: const Column(
        children: 
        [
          Text("No notes here!")
        ]
         
        ),
    );
  }
}

// We are creating an alert box that display cancel/logout upon clicking the logout button, confirming that the user actually wants to log out
/* This is how it works 
 -> First we create a showlogoutdialog method, which is of type future<bool>, so it expects a future of type bool as return value
 -> Inside that, we call the built in method showDialog, which returns a FUTURE OF OPTIONAL VALUES
 -> Since this may not return any values sometimes, like when user quit the dialog box using phone button, it will not return any value
 -> But the showlogoudialog require a value mandatorily, so we use then method to return false by default
 -> Inside the dialog box, we need contents, these are defined inside alertdialog method.
*/
Future<bool> showLogOutDialog(BuildContext context){

  // We are returning this showdialog method which returns a future of optional values, that it, it always returns a future, but sometimes returns a value
  return showDialog<bool>(

    context: context, // This is required parameter
    builder: (context){

      // Now this alert box contains the actual alert message
      return AlertDialog(
        title: const Text("Log out"), // This displays the title of dialog box
        content: const Text("Are you sure you want to log out?"), // This displays the text content in dialog box

        actions: // This actions holds the list of buttons used, here there are two, cancel and log out
        [
          TextButton( // Textbutton for cancel option
            onPressed: () {Navigator.of(context).pop(false);}, // This returns the boolean value false expected by outer function
            child: const Text("Cancel")
          ),

          TextButton( // Textbutton for logout option
            onPressed: () {Navigator.of(context).pop(true);}, // This returns the boolean value true expected by outer function
            child: const Text("Log out")
          )
        ],
      );
    }

  ).then((value) => value ?? false); // Sometimes the showdialog method may not return any value, so to handle that case we use then method.
}
