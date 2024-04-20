// 20/04/2024

// Exceptions

class DatabaseAlreadyOpenException implements Exception {} // If a database is already open and we try to open another database

class InvalidPathException implements Exception {} // If no database exists in the specified path

class DatabaseIsNotOpen implements Exception{} // If database is not open and we try to close the database

class CouldNotDeleteUser implements Exception{} // If there is no user exists to be deleted

class UserAlreadyExists implements Exception{} // If the user Already exists and we try to create another with the same email

class UserDoesNotExists implements Exception{} // If the user does not exist and we try to query them

class CouldNotDeleteNote implements Exception{} // If there is no note exists to be deleted

class CouldNotFindNote implements Exception{} // If the note cannot be found

class CouldNotUpdateNote implements Exception{} // If the note does not exist and we try to update it