import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  User? currentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  String getCurrentUserEmail(){
    String? mail;
    if(currentUser()?.email!=null) {
      mail=currentUser()?.email;
    }
    if(mail==null) return "";
    return mail;
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signIn(String inputEmail, String inputPass) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: inputEmail, password: inputPass);
      print("hereee in signIn" + inputEmail + " " + inputPass);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> register(String inputEmail, String inputPass) async {
    try {
      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: inputEmail,
        password: inputPass,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
