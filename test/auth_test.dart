
import 'package:mynotes2/services/auth_exceptions.dart';
import 'package:mynotes2/services/auth_provider.dart';
import 'package:mynotes2/services/auth_user.dart';
import 'package:test/test.dart';

void main(){
  group('Mock Authentication',(){
     final provider=MockAuthProvider();
    test('should not be initialized to begin with',(){
      expect(provider.isInitialized, false);
    });
    test('cannon log out if not initialized',(){
      expect(provider.logOut, throwsA(const TypeMatcher<NotInitializedException>()));
    });
    test('should be able to be initialized',()async{
     await provider.initialize();
     expect(provider.isInitialized, true);
    });
    test('user should be null after initialization',(){
      expect(provider.currentUser,null);
    });
    test('should be able to initialize in less than 2 seconds',()async{
     await provider.initialize();
      expect(provider.isInitialized, true);
    },timeout: const Timeout(Duration(seconds:2)));
    test('create user should delegate to log in function',()async {
      final badEmailUser=provider.createUser(email: 'foo@bar.com', password: 'password');
      expect(badEmailUser,throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser=provider.createUser(email: 'email', password: 'foobar');
      expect(badPasswordUser, throwsA(const TypeMatcher<WrongPassWordAuthException>()));

      final user=await provider.createUser(email: 'foo', password: 'bar');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified,false);
    });
    test('should be able to log in and log out again',()async{
     await provider.logOut();
     await provider.login(email: 'email', password: 'password');
     final user=provider.currentUser;
     expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception{}
class MockAuthProvider implements AuthProvider{
   AuthUser? _user;
   var _isInitialialized=false;
   bool get isInitialized=>_isInitialialized;


  @override
  Future<AuthUser> createUser({required String email, required String password}) async {
     if(!isInitialized) throw NotInitializedException();
     await Future.delayed(const Duration(seconds:1));
     return login(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async{
    await Future.delayed(const Duration(seconds: 1));
    _isInitialialized=true;
  }

  @override
  Future<void> logOut() async {
    if(!isInitialized) throw NotInitializedException();
    if(_user==null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user=null;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) async {
     if(!isInitialized) throw NotInitializedException();
     await Future.delayed(const Duration(seconds: 1));
     if(email=='foo@bar.com') {
      throw UserNotFoundAuthException();
     }
     else if(password=='foobar'){
       throw WrongPassWordAuthException();
      }
     const user=AuthUser(
      isEmailVerified: false, 
      email: 'foo@bar.com',
      id:'my_id'
      );
     _user=user;
     return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async{
       if(!isInitialized) throw NotInitializedException();
       final user=_user;
       if(user==null) throw UserNotFoundAuthException();
       const newUser=AuthUser(isEmailVerified: true, email: 'foo@bar.com',id:'my_id',);
       _user=newUser;
  }

}