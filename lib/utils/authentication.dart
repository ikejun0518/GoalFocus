import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/model/account.dart';

class Authentication {
  static final _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;
  static Account? myAccount;

  static Future<dynamic> signUp(
      {required String email, required String pass}) async {
    try {
      UserCredential newAccount = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: pass);
      // ignore: avoid_print
      print('Auth登録完了');
      return newAccount;
    } catch (e) {
      // ignore: avoid_print
      print('Auth登録エラー: $e');
      return false;
    }
  }

  static Future<dynamic> emailSignIn(
      {required String email, required String pass}) async {
    try {
      final UserCredential result = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: pass);

      currentFirebaseUser = result.user;
      // ignore: avoid_print
      print('Authサインイン完了');
      return result;
    } catch (e) {
      // ignore: avoid_print
      print('Authサインインエラー:$e');
      return false;
    }
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  static Future<void> deleteAuth() async {
    if (currentFirebaseUser != null) {
      await currentFirebaseUser!.delete();
    }
  }
}
