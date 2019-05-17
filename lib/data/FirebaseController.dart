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

  DatabaseReference reference() {
    return _firebaseDatabase.reference();
  }
}

class FireAppController {
  FirebaseApp _app;

  void init() async {
    _app = await FirebaseApp.configure(
      name: 'fluttertinytaskmanager',
      options: const FirebaseOptions(
        googleAppID: '1:77885632854:android:44d88283e6ec62b2',
        apiKey: 'AIzaSyBJYetOiuGXyf1JyMfEIgOw4Kh5EH9Nq1g',
        databaseURL: 'https://fluttertinytaskmanager.firebaseio.com/',
      ),
    );
  }
}
