import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // 1. Create an instance of Firebase Auth
  // This _auth object is the entry point for all auth operations
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 2. Sign Up with Email & Password
  // This function will be called from your signup_screen.dart
  // 2. Sign Up with Email & Password
  // This function will be called from your signup_screen.dart
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      // 1. Tell Firebase to create the user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. If successful, return the new user object
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // 3. If it fails, catch the error
      // e.g., if the email is already in use or the password is too weak
      print("Error signing up: ${e.message}");
      return null; // Return null if there was an error
    } catch (e) {
      // Catch any other unexpected errors
      print("An unexpected error occurred: $e");
      return null;
    }
  }

  // 3. Sign In with Email & Password
  // This will be called from your login_screen.dart
  // 3. Sign In with Email & Password
  // This will be called from your login_screen.dart
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      // 1. Tell Firebase to sign the user in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. If successful, return the user object
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // 3. If it fails (e.g., wrong password, user not found)
      print("Error signing in: ${e.message}");
      return null; // Return null if there was an error
    } catch (e) {
      print("An unexpected error occurred: $e");
      return null;
    }
  }

  // 4. Sign Out
  // This will be called from a "Logout" button
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<String?> forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      print(e);
      return 'An unexpected error occurred.';
    }
  }

  // 5. Get the current user
  // This is how your 'wrapper.dart' will know if a user is logged in
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }
}
