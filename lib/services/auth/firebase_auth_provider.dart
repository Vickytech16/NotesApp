// 07/04/2024

import 'package:mynotes/services/auth/auth_exception.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart'; 


// In this file, we are going to implement the abstract class we created in auth_provider. This is going to be the catual implementation of firebase auth provider.

class FirebaseAuthProvider implements authProvider
{


  // Implementation of getting current user. We get the value of current user from firebase and pass it to factory constructor
  @override
  Authuser? get currentUser {
  final user = FirebaseAuth.instance.currentUser;
  if (user!=null) {
    return Authuser.fromFirebase(user); } 
  else {
    return null; } 
 }


  // Implementation of registering a new user. Create the user using firebase method, and catch exceptions 
  @override
  Future<Authuser> register({ required String email, required String password, })
     async {

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password); // Firebase will create the user by this method.

        final user=currentUser;
        if (user!=null) {
          return user; } // If user is registered, we will return the user, since the outer function as return type "Authuser"
        else {
          throw UserNotLoggedInAuthExcpetion(); } // If user is null after registration, we throw this exception 
      }

      // This wil catch all firebaseauth exxceptions
      on FirebaseAuthException catch(e)
      {
        switch(e.code)
           {
            case "weak-password":
              throw WeakPasswordAuthException();
            case "invalid-email":
              throw InvalidEmailAuthException();          
            case "email-already-in-use":
              throw EmailAlreadyInUseAuthException();
            default:
              throw GenericAuthException();
          }
      } 

      // This is to handdle general exceptions
      catch(e)
      {
        throw GenericAuthException();
      }
      
  }

  

  @override
  Future<void> sendEmailVerification() async{
    final user=FirebaseAuth.instance.currentUser;
    if (user!=null) {
       await user.sendEmailVerification(); }
    else {
       throw UserNotLoggedInAuthExcpetion(); }
  }
  
  
  // Implementation of login, we log the user, and catch the exceptions
  @override
  Future<Authuser> login({required String email, required String password}) 
   async {
    
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password); // This method will log the user with their mail and password
      final user=currentUser;
      if (user!=null) {
        return user; } // return the user if logged in successfully
      else {
        throw UserNotLoggedInAuthExcpetion(); } 
    }

    // Firebaseauth exceptions are handled here
    on FirebaseAuthException catch(e)
    {
      switch(e.code)
        {
          case "wrong-password":
            throw WrongPasswordAuthException();
          case "invalid-email":
            throw InvalidEmailAuthException();          
          case "user-not-found":
            throw UserNotFoundAuthException();
          case "invalid-credential":
            throw InvalidCredentialAuthException();
          default:
            throw GenericAuthException();
        }    
    }

    // Generic exception block
    catch(e)
    {
      throw GenericAuthException();
    }
  }


  // Implementation of logout, if user is logged in, we log them out, otherwise we throw an exception
  @override
  Future<void> logout() async {
    final user=FirebaseAuth.instance.currentUser;
    if (user!=null) {
       await FirebaseAuth.instance.signOut(); }
    else {
       throw UserNotLoggedInAuthExcpetion(); }
  }

}
