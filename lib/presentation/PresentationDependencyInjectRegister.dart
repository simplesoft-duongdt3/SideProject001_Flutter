
import 'package:flutter_app/domain/DependencyInjectRegister.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

import 'bloc/AddTaskScreenBloc.dart';
import 'bloc/HistoryScreenBloc.dart';
import 'bloc/MainScreenBloc.dart';
import 'bloc/SignInScreenBloc.dart';

class PresentationDependencyInjectRegister extends DependencyInjectRegister {
  @override
  Future<void> register(kiwi.Container di) async {
    //data
    di.registerFactory((c) => AddTaskScreenBloc());
    di.registerFactory((c) => HistoryScreenBloc());
    di.registerFactory((c) => MainScreenBloc());
    di.registerFactory((c) => SignInScreenBloc());
  }
}
