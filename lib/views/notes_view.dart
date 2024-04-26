// 08/04/2024


// We are creating a simple view page to be displayed for users who are logged in and have their email verified
import 'package:flutter/material.dart';
import 'package:mynotes/enums/logout.dart';
import 'package:mynotes/services/auth/auth_services.dart';
import 'package:mynotes/services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  late final NotesService _notesService; // We are creating an instance of noteservice class
  String  get userEmail => AuthServices.firebase().currentUser!.email!; // We are adding ! because we already know the email value cannot be null in notes viewb (If email is null we never got to notes view in first place)

  // We are creating a initstate upon opening the Main UI where we open the database
  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  // We close the database upon closing our main UI
  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }
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

                // This block is to actually allow the user to logout from firebase once they click the logout button
                if(onlogout)
                {
                 await AuthServices.firebase().logout(); // This will logout the client from the firebase
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

      body: FutureBuilder( // This future builder contains the main UI of our application
        future: _notesService.getOrCreateUser(email: userEmail), // This method will create and initialize the user on database

         builder: (context, snapshot) {
           
           // We are calling switch on snapshot
           switch(snapshot.connectionState){      

             // This is when the Future is loaded successfully
             case ConnectionState.done:

              return StreamBuilder( // When the future is loaded successfully, we are returning the stream builder
               stream: _notesService.allNotes, // We are calling the all notes getter

               builder: (context, snapshot)
               {
                 switch (snapshot.connectionState){
                   case ConnectionState.waiting: // In stream builder the process is continuos so we have to catch the waiting statement instead of done
                    return const Text("Notes are loadin buddy");
                   default:
                    return const CircularProgressIndicator();
                 }
               }   
              );

             default:
              return const CircularProgressIndicator(); // While the app is loading
           }
         }
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
