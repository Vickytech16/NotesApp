// 13/04/2024


import "package:path_provider/path_provider.dart";
import "package:sqflite/sqflite.dart";
import "package:path/path.dart" show join;
import "crud_exceptions.dart";
import "crud_constants.dart";
import "database_note.dart";
import "database_user.dart";


// This class is created to serve as a link between our app and 

class NotesService{
   Database? _db; // This variable iwll hold our database

   // This method will check whether the database is open or not, and throw an error if database is not open
   Database _getDatabaseOrThrow() {
    final db=_db;
    if (db==null)
      { throw DatabaseIsNotOpen(); }
    else
      { return db; }
   } 

   // This method will open the database for us
   Future<void> open() async{
    if (_db!=null)
     { throw DatabaseAlreadyOpenException(); } // Check whether database is null. Database should be empty at beginning

   try {
    final docsPath = await getApplicationDocumentsDirectory(); // This will get the folder in which database is present. This method is provided by path_provider.dart
    final dbpath = join(docsPath.path,dbName); // This will append the database name with the database path and give the new string
    final db=await openDatabase(dbpath); // This opens the database
    _db=db;

  // these statements will execute the table creation commands we wrote already
  await db.execute(createUserTable);
  await db.execute(createNotesTable);

   }  on MissingPlatformDirectoryException{
      throw InvalidPathException(); // If no database exists in specified path, this exception is thrown
   }
 }

   // This method will close the database for us
   Future<void> close() async{
    final db=_db;
    if (db==null)
    { throw DatabaseIsNotOpen(); } // If the database is not open, we throw an exception
    else
    {
      await db.close(); // we close the database
      _db=null; // we assign null to the database variable
    }
 }

   // This method will delete a user from the database
   Future<void> deleteUser({required String email}) async{
    final db = _getDatabaseOrThrow(); // First we are checking database is opened

    // This delete method works in this way. First, get thee table name, if email = something, delete the row and return the no of rows deleted
    final deletedCount = await db.delete( // This is a inbuilt method with three parameters
      userTable, // Name of the table
      where: 'email=?', // Which column to be removed
      whereArgs: [email.toLowerCase()] // Condition for deletion
      );

    // Since emails are unique, ideally deletedcount should be 1 if the operation is successful. So we need to throw error on other cases
    if (deletedCount!=1)
    { throw CouldNotDeleteUser(); }
   }

   // This method will create a user to the database
   Future<DatabaseUser> createUser({required String email}) async{
    final db=_getDatabaseOrThrow(); // Getting the database

    final results = await db.query( // First we are querying the database to check if the user already exists or not
      userTable,
      where: 'email: ?',
      whereArgs: [email.toLowerCase()]
      );

    if(results.isNotEmpty)
    { throw UserAlreadyExists(); } // If the user already exists, we throw this exception

    final userID = await db.insert( // This will insert the values to the database
      userTable, 
      {emailColumn: email.toLowerCase()}
      );

      return DatabaseUser(id: userID, email: email); // We have to return the created user
   }

   // This method will be used to query and get the current user from the database
   Future<DatabaseUser> getUser({required String email}) async{
    final db=_getDatabaseOrThrow(); // First we are getting the database

    final results = await db.query( // We query the database to check for the desired user details
      userTable, 
      limit: 1,
      where: 'Email = ?',
      whereArgs: [email.toLowerCase()]
    );

    if (results.isEmpty)
    { throw UserDoesNotExists();}
    else
    { return DatabaseUser.fromRow(results.first); } // If the user exists, we will return the user
    
   }

   // This method will allow us to create new notes
   Future<DatabaseNote> createNote({required DatabaseUser owner}) async{
    final db = _getDatabaseOrThrow(); // we are checking the database is open
    const text = ''; // This is the placeholder text present in the note

    final dbUser = await getUser(email: owner.email); // We are checking whether the user exists or not
    if (dbUser!=owner) // We have to validate whether the existing user is the owner of the account, and throw appropriate error
     { throw UserDoesNotExists(); }

    final noteID = await db.insert( // We are inserting the actual notes
      noteTable,
      {
        userIDColumn: owner.id,
        textColumn: text,
        isSyncedWithCloudColumn: 1
      });

    final note = DatabaseNote(id: noteID, userID: owner.id, text: text, isSyncedWithCloud: true); // We create a instance of inserted note to return it

    return note;
   }

   // This method will allow us to delete the existing notes
   Future<void> deleteNote({required int id}) async{
    final db = _getDatabaseOrThrow();

    final deleteCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id]);

    if (deleteCount==0)
    { throw CouldNotDeleteNote();}
   }

   // This method will allow us to delete all notes
   Future<int> deleteAllNotes() async{
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable); // We are just deleting the entire table and return the deleted count


   }

   // This method allows us to view a specific note
   Future<DatabaseNote> getNote({required int id}) async{
    final db = _getDatabaseOrThrow();

    final notes = await db.query( // Fetching the database
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id]);

    if (notes.isEmpty)
      { throw CouldNotFindNote(); } // 
    else
      { return DatabaseNote.fromRow(notes.first); }
   }

   // This method allow us display all notes, in the main interface
   Future<Iterable<DatabaseNote>> getAllNote() async{
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable); // We are querying the entire table

    return notes.map((notesRow) => DatabaseNote.fromRow(notesRow) ); // We are converting notes variable (string) into iterable type and return
   }
 
   // This allows us to update a existing note
   Future<DatabaseNote> updateNote({required DatabaseNote note, required String text}) async{
    final db = _getDatabaseOrThrow();

    await getNote(id: note.id); // We have to check this Note already exists

    final updatesCount = await db.update( // Update takes two arguements, table name and a map containing all fields to be updated
      noteTable, 
      {
        textColumn: text, // We update the notes with new text
        isSyncedWithCloudColumn: 0, // We update this field to 0, since we changed this note and it was not synced with cloud as for now 
      });

    if (updatesCount==0)
    { throw CouldNotUpdateNote(); }
    else
    { return await getNote(id: note.id); } // We just call the getnote method here
   }
 }


