import 'package:mynotes2/services/auth_provider.dart';
import 'package:mynotes2/services/auth_user.dart';
import 'package:mynotes2/services/firebase_auth.dart';

class AuthService implements AuthProvider{
  
   
 
  final AuthProvider provider;

  const AuthService(this.provider);
 factory AuthService.firebase()=>AuthService(FirebaseAuthProvider());
 
  @override
  Future<void> initialize()=>provider.initialize();

  @override
  Future<AuthUser> createUser({required String email, required String password})=>provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser =>provider.currentUser;

  @override
  Future<void> logOut()=>provider.logOut();

  @override
  Future<AuthUser> login({required String email, required String password})=>provider.login(email: email, password: password);

  @override
  Future<void> sendEmailVerification()=>provider.sendEmailVerification();
  
  
   
}