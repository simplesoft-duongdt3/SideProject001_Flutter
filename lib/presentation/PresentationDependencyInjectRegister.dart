import 'package:flutter_app/domain/DependencyInjectRegister.dart';
import 'package:flutter_app/presentation/bloc/FriendScreenBloc.dart';
import 'package:flutter_app/presentation/route/RouteProvider.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

import 'bloc/AddTaskScreenBloc.dart';
import 'bloc/HistoryScreenBloc.dart';
import 'bloc/TaskDetailScreenBloc.dart';
import 'bloc/TaskScreenBloc.dart';
import 'bloc/TodayTodosScreenBloc.dart';
import 'bloc/ShareQrScreenBloc.dart';
import 'bloc/SignInScreenBloc.dart';

class PresentationDependencyInjectRegister extends DependencyInjectRegister {
  @override
  Future<void> register(kiwi.Container di) async {
    //presentation
    di.registerSingleton((c) => RouterProvider());
    di.registerFactory((c) => AddTaskScreenBloc());
    di.registerFactory((c) => HistoryScreenBloc());
    di.registerFactory((c) => TodayTodosScreenBloc());
    di.registerFactory((c) => SignInScreenBloc());
    di.registerFactory((c) => ShareQrScreenBloc());
    di.registerFactory((c) => TaskScreenBloc());
    di.registerFactory((c) => TaskDetailScreenBloc());
    di.registerFactory((c) => FriendScreenBloc());
  }
}
