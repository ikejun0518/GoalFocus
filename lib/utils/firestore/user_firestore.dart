import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/utils/authentication.dart';

import '../../model/account.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users =
      _firestoreInstance.collection('users');

  static Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
        'uid': newAccount.id,
        'user_id': newAccount.userId,
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now()
      });

      // ignore: avoid_print
      print('新規ユーザー作成完了');
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('新規ユーザー作成エラー :$e');
      return false;
    }
  }

  static Future<dynamic> getUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      Account myAccount = Account(
          id: uid,
          name: data['name'],
          userId: data['user_id'],
          createdTime: data['created_time'],
          updatedTime: data['updated_time']);

      Authentication.myAccount = myAccount;

      // ignore: avoid_print
      print('ユーザー取得完了');
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('ユーザー取得失敗');
      return false;
    }
  }
}
