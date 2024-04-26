// 13/04/2024


import "dart:async";

import "package:path_provider/path_provider.dart";
import "package:sqflite/sqflite.dart";
import "package:path/path.dart" show join;
import "crud_exceptions.dart";
import "crud_constants.dart";
import "database_note.dart";
import "database_user.dart";


// This class is created to serve as a link between our app and 

class NotesService{
   Database? _db; // This variable will hold our database

   /* This will holf the list of all notes that are created by user. This functions as Database variable that holds all the notes created by user in a list. 
   This list since holds all notes, it can also be supplied to streams  */
   List<DatabaseNote> _notes = []; 


   static final NotesService _shared = NotesService._sharedInstance();
   NotesService._sharedInstance();
   factory NotesService() => _shared;

   // Here we are creating a stream controller, which will track the changes that occur in a list over a given time. Broadcast means we can check these changes multiple time 
   final _notesStreamController = StreamController<List<DatabaseNote>>.broadcast();

   // We are creating this getter to hold all the notes in a list
   Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

   // This method will be used to get all the notes and supply it to our list and stream
   Future<void> _cacheNotes() async {
    final allNotes = await getAllNote(); // We use our getallNotes function to get all of the user created notes
    _notes = allNotes.toList(); // We supply all these notes to the Database list
    _notesStreamController.add(_notes); // We add our list to stream controller so from now on all changes on our list will be tracked
   }

   // This method will work as a interface between our UI and Notes service. This method will create or Get user as per the requirement
   Future<DatabaseUser> getOrCreateUser ({required String email}) async{
    try{
      final user = await getUser(email: email);
      return user;
    } on UserDoesNotExists {
      final createdUser = await createUser(email: email); 
      return createdUser;
    }
   }



   // This method will check whether the database is open or not, and throw an error if database is not open
   Database _getDatabaseOrThrow() {
    final db=_db;
    if (db==null)
      { throw DatabaseIsNotOpen(); }
    else
      { return db; }
   } 


   // This method will ensure the database is already open 
   Future<void> _ensureDBisOpen() async{
    try {
      await open();
    } on DatabaseAlreadyOpenException{
      // Leave this empty
    }
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

  await _cacheNotes(); // We are calling this method to supply all our notes to the List<Database> Streams upon opening the database.

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
    await _ensureDBisOpen();
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
    await _ensureDBisOpen();
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
    await _ensureDBisOpen();
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
    await _ensureDBisOpen();
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

    _notes.add(note); // Since we created a new note, we need to add it to our list
    _notesStreamController.add(_notes); // Since we modified our list, we should update is as well.

    return note;
   }

   // This method will allow us to delete the existing notes
   Future<void> deleteNote({required int id}) async{
    await _ensureDBisOpen();
    final db = _getDatabaseOrThrow();

    final deleteCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id]);

    if (deleteCount==0){
      throw CouldNotDeleteNote(); }
    else {
      _notes.removeWhere((note) => id == note.id ); // We are removing the deleted note from our list
      _notesStreamController.add(_notes); // We need to update our stream as well
    }
   }

   // This method will allow us to delete all notes
   Future<int> deleteAllNotes() async{
    await _ensureDBisOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(noteTable); // We are just deleting the entire table

    _notes = []; // We make the list empty (remove all notes)
    _notesStreamController.add(_notes); // We need to update the stream controllers

    return numberOfDeletions;

   }

   // This method allows us to view a specific note
   Future<DatabaseNote> getNote({required int id}) async{
    await _ensureDBisOpen();
    final db = _getDatabaseOrThrow();
    
    final notes = await db.query( // Fetching the database
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id]);

    if (notes.isEmpty)
      { throw CouldNotFindNote(); } // 
    else
      { 
        final note = DatabaseNote.fromRow(notes.first); 
        
        // When we fetch a note from our app, it won't have it current changes updated automatically. So to ensure that, we delete and add the note.
        _notes.removeWhere((note) => note.id == id); 
        _notes.add(note);
        _notesStreamController.add(_notes); // Updating stream controller
        
        return note;
      }
   }

   // This method allow us display all notes, in the main interface
   Future<Iterable<DatabaseNote>> getAllNote() async{
    await _ensureDBisOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable); // We are querying the entire table

    return notes.map((notesRow) => DatabaseNote.fromRow(notesRow) ); // We are converting notes variable (string) into iterable type and return
   }
 
   // This allows us to update a existing note
   Future<DatabaseNote> updateNote({required DatabaseNote note, required String text}) async{
    await _ensureDBisOpen();
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
    { 
      final updateNote = await getNote(id: note.id);  // We just call the getnote method here

      _notes.removeWhere((note) => note.id == updateNote.id ); // 
      _notes.add(updateNote);
      _notesStreamController.add(_notes);

      return updateNote;
    
    } 
   }
 }


