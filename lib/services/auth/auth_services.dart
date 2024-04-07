// 07/04/2024

// We aregoing to create a auth services class from which auth provider is implemented. This class serves as 
// interface between UI and auth provider

import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

class AuthServices implements authProvider
{
  final authProvider provider; // This variable is of type auth provider. It acts as an instance of authprovider and helps us to access all of its methods.
  const AuthServices(this.provider); // We use the authprovider variable to link between auth provider and auth services.


  // implementation of currentuser
  @override
  Authuser? get currentUser 
    => provider.currentUser; 


  // implementation of login
  @override
  Future<Authuser> login({required String email, required String password}) 
    => provider.login(email: email, password: password); 



  // implementation of logout
  @override
  Future<void> logout() 
    => provider.logout();


  // implementation of register
  @override
  Future<Authuser> register({required String email, required String password}) 
    => provider.register(email: email, password: password);

  
  // implementation of send email verification
  @override
  Future<void> sendEmailVerification() 
    => provider.sendEmailVerification();
  
}