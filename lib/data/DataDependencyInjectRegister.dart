import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/domain/DependencyInjectRegister.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:firebase_database/firebase_database.dart';
import 'FirebaseController.dart';
import 'RepositoryImpl.dart';

class DataDependencyInjectRegister extends DependencyInjectRegister {
  @override
  Future<void> register(kiwi.Container di) async {
    //data
    final FireAppController fireAppController = FireAppController();
    fireAppController.init();
    di.registerSingleton((c) => fireAppController);
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
    di.registerSingleton<EventRepository, EventRepositoryImpl>(
        (c) => EventRepositoryImpl());
    di.registerSingleton<UserRepository, UserRepositoryImpl>(
        (c) => UserRepositoryImpl());
  }
}
