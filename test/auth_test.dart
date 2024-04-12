// 09/04/2024

import "package:mynotes/services/auth/auth_exception.dart";
import "package:mynotes/services/auth/auth_provider.dart";
import "package:mynotes/services/auth/auth_user.dart";
import "package:test/test.dart";

void main() {  

  // We are grouping all our tests together
  group('Mock tests', () {
    
    final provider=MockAuthProvider(); // Creating an instance of mockauthprovider


    // Creating a test to check intialize app
    test('Should be uninitialized to begin with',() {
      expect(provider._isInitialized, false); // The test will pass if the app is unitialized at start
    });


    // Creating a test to check logout
    test('Cannot logout if not initialized',() {
      // This test has two parts, upon logout, if Notinitialized exception occurs, catch that exception
      expect(
        provider.logout(),
          throwsA(const TypeMatcher<NotInitializedException>()), // throwsA throw an exception of given type, here it is notinitialized exception
      );
    });


    // Creating a test to ensure app is intialized once we call the initialize method
    test('Should be able to initialize upon calling the method',() async {
        await provider.initialize(); // Calling the initialize method
        expect(provider._isInitialized,true); // Firebase should be initialized by now
    });


    // Creating a test to ensure user is null after initialization
    test('User should be null upon initialization',() {
      expect(provider.currentUser, null); // We are checking there are no users immediately after initializing firebase
    });


    // Creating a Test to check the initialization cost only 2 seconds of time
    test('The firebase initialization should not take more than 3 seconds',() async{
      await provider.initialize(); 
      expect(provider._isInitialized,true);
    },
    timeout: const Timeout(Duration(seconds: 3)) // The function will throw error if the process take more than 3 seconds to execute
    );


    // Creating a Test to check forbidden Email
    test('To return exception when we try to login using forbidden email',() {    
      final badEmailID=provider.login(email: "foo@bar.com", password: "anypass"); // We are logging in with forbidden email id
      expect(badEmailID,
        throwsA(const TypeMatcher<EmailAlreadyInUseAuthException>())); // we are trying to catch email alrady in use exception
    });


    // Creating a Test to check forbidden password
    test('To return exception when we try to login using forbidden password',() {
      final badpassword=provider.login(email: "Myemail@gmail.com", password: "foobar"); // We are logging in with forbidden password
      expect(badpassword,
        throwsA(const TypeMatcher<WrongPasswordAuthException>())); // We are trying to catch wrong password exception
    });


    // Creating a test to check that we can actually register with correct credentials
    test('To create a user and check everything is right',(){
      final correctuser=provider.register(email: "myboi@gmail.com", password: "Venommmmmm"); // We are creating a user with right credentials
      expect(provider.currentUser,correctuser); // We are checking the new user is logged in and assigned to current user
      expect(provider.currentUser?.isEmailVerified, false); // We are checking the user email is UNVERIFIED by default
    });


    // Creating a test to ensure upon sending email verification, the user's email is verified
    test('To send Email verification and ensure its working correctly',() async{
      provider.sendEmailVerification(); // We are sending verification mail to user
      final user=provider.currentUser; // We are assinging current user to user
      expect(user, isNotNull); // Currentuser shouldn't be null
      expect(user!.isEmailVerified, true); // user email should be verified
    });


    // Checking we can logout and login correctly
    test('To test the standard operation(logout and login)',() async{
      await provider.logout(); // We are logging out
      await provider.login(email: "helloworld", password: "byeworld"); // We are logging in again
      expect(provider.currentUser, isNotNull); // Checking the current user isn't null
    });



  }); // End of test group

} // Enf of main function


// This class will ensure that the firebase is inialized before Running firebase functions
class NotInitializedException implements Exception {}


class MockAuthProvider implements authProvider{

  Authuser? _user; // We create a nullable user variable, which we use as a mock user, and return as the currentuser value

  /* In Mock environment, we have to check whether the initialize() method is working correctly as well. For this, we need to ensure the firebase is
     Actually unitialized at the start of the test. So we declare a variable for that. Also we need to make sure firebase is initialized before other
     methods like login/register etc. So we need to throw a exception there as well. */

  var _isInitialized = false; // This variable stores the value whether inialization occured or not. _ represents private variable here.
  bool get isInitialized => _isInitialized; // We create a boolean method (getter), which can be accessed by . operaator.


  @override
  // TODO: implement currentUser
  Authuser? get currentUser => _user;

  @override
  Future<void> initialize() async{
    await Future.delayed(Duration(seconds: 2)); // We create a FAKE 2 second wait for testing purpose
    _isInitialized=true;
  }


  @override
  Future<Authuser> login({required String email, required String password}) {

    if (!isInitialized)  throw NotInitializedException();  // We are checking the Firebase is initialized

    // Creating fake test scenarios
    if (email=="foo@bar.com") throw EmailAlreadyInUseAuthException();
    if (password=="foobar") throw WrongPasswordAuthException();

  const user = Authuser(isEmailVerified: false); // Creating a mock user
  _user=user; // Assigning the mock user to our user variable
  return Future.value(_user); // We return the future of our mock user
  }

  @override
  Future<void> logout() async{
    if (!isInitialized)  throw NotInitializedException();  // We are checking the Firebase is initialized
    if (_user==null) throw UserNotFoundAuthException(); // We need to be logged in first to logout, we are checking that here
    await Future.delayed(Duration(seconds: 2)); // Fake wait
    _user=null; // Since we are logged out, set user as null

  }

  @override
  Future<Authuser> register({required String email, required String password}) 
   async {

    if (!isInitialized)  throw NotInitializedException();  // We are checking the Firebase is initialized
    await Future.delayed(Duration(seconds: 2)); // We create a FAKE 2 second wait for testing purpose
    return login(email: email, password: password); // We calling the login method, so the registered users are logged in automatically
  }


  @override
  Future<void> sendEmailVerification() async{
    if (!isInitialized)  throw NotInitializedException();  // We are checking the Firebase is initialized

    if (_user==null) throw UserNotFoundAuthException(); // Checking we actually have a user

    const newuser=Authuser(isEmailVerified: true); // We create a new user whose email verified value is true
    _user=newuser; // If we do have a user, we set their emailverified to true. For that we have to create new user since we can't change the value inside the method parameter.
  }

  
}