// 05/04/2024

import 'package:mynotes/services/auth/auth_user.dart';

// We are creating a abstract class with methods for all authentication actions. This is just a blue print and can be extended by other classes.
// For example, both google login and email login methods can extend this class and define their own methods.

// ignore: camel_case_types
abstract class authProvider{

 Authuser? get currentUser; // We are getting the value of currentuser, we implement null safety since currentuser can be null

 Future<void> initialize(); // This will initialize the firebaseapp

 // We are creating login method which will return a Future (usercredential), it takes two mandatory parameters, that's why we used required keyword
 Future<Authuser> login({ 
  required String email,
  required String password, });

 // Same like login, we are creating a method for register which will return a future and take two mandatory parameters
 Future<Authuser> register({
  required String email,
  required String password, });

 Future<void> sendEmailVerification(); // This will send the Email verification

 Future<void> logout(); // This will logout the user

}