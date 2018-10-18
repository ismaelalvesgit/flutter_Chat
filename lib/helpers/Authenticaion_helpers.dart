import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthHelpers{

  final googleSingIn = GoogleSignIn();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser userOn;

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
    await auth.signInWithEmailAndPassword(email: email, password: password).then((user){
      userOn = user;
    });
    return userOn.email;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await auth.currentUser();
    return user != null ? user.email : null;
  }

  Future<void> signOut() async{
    return auth.signOut();
  }

}


