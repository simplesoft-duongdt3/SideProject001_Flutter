import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

import '../../main.dart';

class ShareQrScreenBloc {
  UserRepository _userRepository = diResolver.resolve();

  Future<LoginUserPresentationModel> getCurrentUser() async {
    var user = await _userRepository.getCurrentUser();
    return _mapUser(user);
  }

  LoginUserPresentationModel _mapUser(LoginUserDomainModel user) {
    LoginUserPresentationModel result;
    if (user != null) {
      result = LoginUserPresentationModel(
          user.uid, user.userName, user.email, user.getQrCodeContent());
    }

    return result;
  }
}
