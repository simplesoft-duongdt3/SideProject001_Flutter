import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import 'FirebaseDataModel.dart';

class FireAuthController {
  final FirebaseAuth _firebaseAuth = diResolver.resolve();
  final GoogleSignIn _googleSignIn = diResolver.resolve();

  Future<void> _signOutIfNeed() async {
    var user = await _firebaseAuth.currentUser();
    if (user != null) {
      await _firebaseAuth.signOut();
    }
  }

  Future<void> signOut() async {
    await _signOutIfNeed();
  }

  Future<void> signInWithGoogle() async {
    await _signOutIfNeed();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<bool> isLogin() async {
    var currentUser = await getLoginUser();
    return currentUser != null;
  }

  Future<LoginUserFirebaseDataModel> getLoginUser() async {
    var currentUser = await _firebaseAuth.currentUser();
    if (currentUser != null) {
      return LoginUserFirebaseDataModel(
          currentUser.uid, currentUser.displayName, currentUser.email);
    }
    return null;
  }
}

class FireDatabaseController {
  final FirebaseDatabase _firebaseDatabase = diResolver.resolve();

  DatabaseReference getUserRef(String uid) {
    return _firebaseDatabase.reference().child("user/$uid");
  }

  DatabaseReference getFriendRequestRef() {
    return _firebaseDatabase.reference().child("friend_request");
  }

  DatabaseReference getDailyTaskRef(String uid) {
    return _firebaseDatabase.reference().child("task/$uid");
  }

  DatabaseReference getDailyTaskWithIdRef(String uid, String taskId) {
    return _firebaseDatabase.reference().child("task/$uid/$taskId");
  }

  DatabaseReference getDailyTaskHistoryRef(String uid) {
    return _firebaseDatabase.reference().child("task_history/$uid");
  }

  DatabaseReference getDailyTaskHistoryWithIdRef(String uid, String historyId) {
    return _firebaseDatabase.reference().child("task_history/$uid/$historyId");
  }

  DatabaseReference getOneTimeTaskRef(String uid) {
    return _firebaseDatabase.reference().child("one_time_task/$uid");
  }

  DatabaseReference getOneTimeTaskWithIdRef(String uid, String oneTimeTaskId) {
    return _firebaseDatabase.reference().child("one_time_task/$uid/$oneTimeTaskId");
  }

  DatabaseReference getOneTimeTaskHistoryRef(String uid) {
    return _firebaseDatabase.reference().child("one_time_task_history/$uid");
  }

  DatabaseReference getOneTimeTaskHistoryWithIdRef(String uid, String historyId) {
    return _firebaseDatabase.reference().child("one_time_task_history/$uid/$historyId");
  }
}

class FireAppController {
  Future<void> init() async {
    await FirebaseApp.configure(
      //TODO firebase info
    );
  }
}
