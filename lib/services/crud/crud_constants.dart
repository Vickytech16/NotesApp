// 20/04/2024

// Map constants
const idColumn = "id";
const emailColumn = "email";
const userIDColumn = "userid";
const textColumn = "text";
const isSyncedWithCloudColumn = "is_synced_with_cloud";

// Database constants
const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'User';

// SQL constants
  
// Create the user table
const createUserTable = 
    '''
  CREATE TABLE IF NOT EXISTS "User" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)  );  
    ''';  

// Create the notes table
const createNotesTable =
    '''
  CREATE TABLE IF NOT EXISTS "note" (
	"id"	INTEGER NOT NULL,
	"userid"	INTEGER NOT NULL UNIQUE,
	"text"	TEXT,
	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	FOREIGN KEY("userid") REFERENCES "User"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)  );
    ''';


