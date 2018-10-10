import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {

  Future<String> currentUser();
  Future<String> signIn(String email, String password);
  Future<void> signOut();
}

class AuthHelpers implements BaseAuth{

  final googleSingIn = GoogleSignIn();
  final auth = FirebaseAuth.instance;


  Future<Null> loginGoogle() async {
    GoogleSignInAccount user = googleSingIn.currentUser;

    if (user == null) user = await googleSingIn.signInSilently();
    if (user == null) user = await googleSingIn.signIn();
    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication crenentials =
      await googleSingIn.currentUser.authentication;

      await auth.signInWithGoogle(
          idToken: crenentials.idToken, accessToken: crenentials.accessToken);
    }
  }

  Future<String> signIn( String email, String password) async{
    FirebaseUser user = await auth.signInWithEmailAndPassword(email: email, password: password);

    return user.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await auth.currentUser();
    return user != null ? user.uid : null;
  }

  Future<String> userOn() async{
    FirebaseUser user = await auth.currentUser();

    return user.email;
  }

  Future<void> signOut() async{
    return auth.signOut();
  }

}


