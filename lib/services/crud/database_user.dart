// 20/04/2024

// We declare a class to define each of the user of our app using id and email of the user
import 'package:flutter/foundation.dart';
import 'crud_constants.dart';

@immutable
class DatabaseUser {
  final int id; // unique identifier for each user
  final String email; // email id of each user


  // We create a constructor for our class and make id and email default parameters
   const DatabaseUser({ 
    required this.id,
    required this.email,
    });

  // We are creating this method which takes a map as arguement and assign the value in the map to our id and email fields.
  DatabaseUser.fromRow(Map<String,Object?> map) :
    id = map[idColumn] as int, // the id field will point to map["id"] value
    email = map[emailColumn] as String; // the email field will point to map["email"] value

  // We are overriding tostring method because if we didn't do it and try to print DatabaseUser, it will print "instance of class".
  @override
  String toString() => "Person, ID = $id, email = $email"; // Now it will print something like "Person,ID = 'id val, email= 'email val"

  // We are overriding the == operator to allow us to compare between id values
  @override
  bool operator == (covariant DatabaseUser other) => id == other.id;
  
  // For covariants we should always create hashcodes
  @override
  int get hashCode => id.hashCode;
  
}
