import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/data/FirebaseController.dart';
import 'package:flutter_app/data/FirebaseDataModel.dart';
import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/main.dart';

class UserRepositoryImpl implements UserRepository {
  FireAuthController _fireAuthController = diResolver.resolve();
  FireDatabaseController _fireDatabaseController = diResolver.resolve();

  Future<LoginUserFirebaseDataModel> _getLoginUser() async {
    LoginUserFirebaseDataModel loginUser =
        await _fireAuthController.getLoginUser();
    return loginUser;
  }

  @override
  Future<void> signInWithGoogleAccount() async {
    await _fireAuthController.signInWithGoogle();

    LoginUserFirebaseDataModel loginUser = await _getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      DataSnapshot userData =
          await _fireDatabaseController.getUserRef(uid).once();
      if (userData.value == null) {
        await _fireDatabaseController.getUserRef(uid).set(loginUser.toJson());
      }
    }
  }

  @override
  Future<void> logout() async {
    await _fireAuthController.signOut();
  }

  @override
  Future<bool> isLogin() async {
    var isLogin = await _fireAuthController.isLogin();
    return isLogin;
  }

  @override
  Future<LoginUserDomainModel> getCurrentUser() async {
    var mapLoginUser = await _getLoginUser();
    return _mapLoginUser(mapLoginUser);
  }

  LoginUserDomainModel _mapLoginUser(LoginUserFirebaseDataModel loginUser) {
    LoginUserDomainModel result;
    if (loginUser != null) {
      result = LoginUserDomainModel(
          loginUser.uid, loginUser.userName, loginUser.email);
    }
    return result;
  }
}
