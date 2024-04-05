import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {

    var email = "fredrik@gmail.com";

    assert(EmailValidator.validate(email));
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  // Register a new user with email and password
  Future<UserCredential?> signUp(String email, String password, String name, String phoneNumber) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (userCredential.user != null && name.isNotEmpty && phoneNumber.isNotEmpty) {
      // Store user data in the database for 'users' node
      String userId = userCredential.user!.uid;
      await _databaseReference.child('users').child(userId).set({
        'id': userId,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
      });
      // Also store user data in the database for 'drivers' node
      await _databaseReference.child('drivers').child(userId).set({
        'id': userId,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
      });
    }
    return userCredential;
  } catch (e) {
    print("Error signing up: $e");
    return null;
  }
}

  // Sign in with email and password
  Future<UserCredential?> signIn(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (userCredential.user != null) {
      // Check if the user exists in the 'users' node
      DatabaseEvent userEvent = await _databaseReference.child('users').child(userCredential.user!.uid).once();
      DataSnapshot userSnapshot = userEvent.snapshot;

      // Check if the user exists in the 'drivers' node
      DatabaseEvent driverEvent = await _databaseReference.child('drivers').child(userCredential.user!.uid).once();
      DataSnapshot driverSnapshot = driverEvent.snapshot;

      if (userSnapshot.exists && driverSnapshot.exists) {
        // User exists in both 'users' and 'drivers' nodes, proceed with login
        return userCredential;
      } else {
        // User does not exist in both nodes, sign out and return null
        await _auth.signOut();
        return null;
      }
    }
  } catch (e) {
    print("Error signing in: $e");
    return null;
  }
}

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  // Check if a user is signed in
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Listen for authentication state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
