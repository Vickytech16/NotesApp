// 20/04/2024

// We are creating a class for our notes table, we declare fields and initialize constructor
import 'package:flutter/foundation.dart';
import 'crud_constants.dart';

@immutable
class DatabaseNote{
  final int id;
  final int userID;
  final String text;
  final bool isSyncedWithCloud;

  const DatabaseNote({
    required this.id,
    required this.userID,
    required this.text,
    required this.isSyncedWithCloud,
 });

  // We are creating this method to assign values for our map
  DatabaseNote.fromRow(Map<String,Object?> map) :
    id = map[idColumn] as int, // the id will point to idcolumn
    userID = map[userIDColumn] as int, // the userid will point to useridcolumn
    text = map[textColumn] as String, // the text will poin to textcolumn
    isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1 ? true : false; // Since we declared issyncedwithcloud as bool, we have to convert the integer value into boolean value and return the value

  // to use tostring to print the fields inside this class
  @override
  String toString() => "note, ID = $id, userID = $userID, isSyncedWithCloud = $isSyncedWithCloud"; // 

  // We are overriding the == operator to allow us to compare between id values
  @override
  bool operator == (covariant DatabaseNote other) => id == other.id;
  
  // For covariants we should always create hashcodes
  @override
  int get hashCode => id.hashCode;
      

}