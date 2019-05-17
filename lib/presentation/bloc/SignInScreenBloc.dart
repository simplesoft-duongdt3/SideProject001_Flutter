import 'package:flutter_app/domain/Repository.dart';

import '../../main.dart';

class SignInScreenBloc {
  UserRepository _userRepository = diResolver.resolve();

  Future<bool> signInWithGoogleAccount() async {
    await _userRepository.signInWithGoogleAccount();
    var isLogin = await _userRepository.isLogin();
    return isLogin;
  }
}
