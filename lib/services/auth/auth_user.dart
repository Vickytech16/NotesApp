// 05/04/2024

import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

// We are creating a class Authuser that store user info. We make it immutable so it can only have final/const arguements
@immutable 
class Authuser{

 final bool isEmailVerified; // This holds the data whether the user email is verified or not
 const Authuser({required this.isEmailVerified}); // Constructor for this class, we make this required parameter to improve code readability.

 /* We are creating a factory constructor, which will automatically create and assign objects for us. How this one works is, we are getting the user
    variable of type "User" from firebase, and assigning the user.emailverified (built in variable) to the "isEmailVerified" variable in our class */
 factory Authuser.fromFirebase(User user) => Authuser(isEmailVerified: user.emailVerified);


}

