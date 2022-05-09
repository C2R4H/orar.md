import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> createAnonymousAccount() async {
    await auth.signInAnonymously().then((result) {
      User? user = result.user;
      print(user!.uid);
      return true;
    });
    return false;
  }

  Future<bool> logout() async {
    User? user = auth.currentUser;
    if (user != null) {
      user.delete();
      await auth.signOut().then((data) {
        return true;
      });
    }else{
      print('ERORR LOGGING OUT');
    }
    return false;
  }
}
