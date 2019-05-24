import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/data/repository_impl/TaskRepositoryImpl.dart';
import 'package:flutter_app/data/repository_impl/UserRepositoryImpl.dart';
import 'package:flutter_app/domain/DependencyInjectRegister.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

import 'FirebaseController.dart';

class DataDependencyInjectRegister extends DependencyInjectRegister {
  @override
  Future<void> register(kiwi.Container di) async {
    //data
    di.registerSingleton((c) async {
      final FireAppController fireAppController = FireAppController();
      await fireAppController.init();
      return fireAppController;
    });
    di.registerSingleton((c) => FireDatabaseController());
    di.registerSingleton((c) => FirebaseAuth.instance);
    di.registerSingleton((c) {
      var firebaseDatabase = FirebaseDatabase.instance;
      firebaseDatabase.setPersistenceEnabled(true);
      firebaseDatabase.setPersistenceCacheSizeBytes(50 * 1024 * 1024);
      return firebaseDatabase;
    });
    di.registerSingleton((c) => FireAuthController());
    di.registerFactory((c) => GoogleSignIn());
    di.registerSingleton<TaskRepository, TaskRepositoryImpl>(
            (c) => TaskRepositoryImpl());
    di.registerSingleton<UserRepository, UserRepositoryImpl>(
        (c) => UserRepositoryImpl());
  }
}
