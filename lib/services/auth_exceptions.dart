//login exception
class UserNotFoundAuthException implements Exception{}
class WrongPassWordAuthException implements Exception{}

//register exception 
class WeakPasswordAuthException implements Exception{}
class EmailAlreadyInUseAuthException implements Exception{}
class InvalidEmailAuthException implements Exception{}
//Generic Exception
class GenericAuthException implements Exception{}
class UserNotLoggedInAuthException implements Exception{}

class UserShouldBeSetBeforeReadingAllNotes implements Exception{}