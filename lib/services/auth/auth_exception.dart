// 05/04/2024

// In this file, we will define all the firebaseauth exceptions


// Generic exceptions
class InvalidEmailAuthException implements Exception {}
class GenericAuthException implements Exception {}
class UserNotLoggedInAuthExcpetion implements Exception {}
 

// Registration exceptions
class WeakPasswordAuthException implements Exception {}
class EmailAlreadyInUseAuthException implements Exception {}


// Login exceptions
class WrongPasswordAuthException implements Exception {}
class UserNotFoundAuthException implements Exception {}
class InvalidCredentialAuthException implements Exception {}
