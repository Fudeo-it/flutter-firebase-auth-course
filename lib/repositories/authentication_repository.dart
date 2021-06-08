import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:telegram_app/exceptions/already_existing_account_exception.dart';
import 'package:telegram_app/exceptions/sign_in_canceled_exception.dart';
import 'package:telegram_app/exceptions/wrong_credentials_exception.dart';

class AuthenticationRepository {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthenticationRepository({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fimber.e('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Fimber.e('Wrong password provided for that user.');
      }

      throw new WrongCredentialsException();
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await firebaseAuth.signInWithCredential(credentials);
    }

    Fimber.e('User canceled the login process');
    throw new SignInCanceledException();
  }

  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fimber.e('The account already exists for that email.');
        throw new AlreadyExistingAccountException();
      }
    }
  }
}
