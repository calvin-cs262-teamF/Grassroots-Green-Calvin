/*  auth.dart
*
* A class to handle authorization of users in the application
*
*/
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  /// Base class for an authentication method.
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<String> getCurrentUser();
  Future<String> getUserName();
  Future<void> signOut();
  Future<DocumentSnapshot> getUserData();
  Future<bool> isSignedIn();
}

class Auth implements BaseAuth {
  /// Authenticator for email sign-in.

  /// Access to the Firebase authenticator.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Signs the user in using Firebase.
  Future<String> signIn(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    // TODO: only save email if it hasn't been set before (although this does work correctly)
    Firestore.instance.collection('users').document(user.uid).updateData({'email': email});
    return user.uid;
  }

  /// Gets data for the Firebase authenticated user.
  Future<DocumentSnapshot> getUserData() async {
    if(await getCurrentUser() == null) {
      return null;
    } else {
      return Firestore.instance.collection('users').document(await getCurrentUser()).get();
    }
  }

  /// signs a new user up using Firebase.
  Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    Firestore.instance.collection('users').document(user.uid).setData({'email': email});
    return user.uid;
  }

  /// Gets the current user's code for Firebase user data access.
  Future<String> getCurrentUser() async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      if(user == null) {
        return null;
      } else {
        return user.uid;
      }
    } catch(error) {
      print("Error getting the current user.");
      return null;
    }
  }

  /// Gets the display name for the user.
  ///
  /// The user's name is currently displayed as their email address.
  Future<String> getUserName() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if(user == null) {
      return null;
    } else {
      return user.email;
    }
  }

  /// Signs the current user out from Firebase authentication.
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    try {
      return await getCurrentUser() != null;
    } catch(error) {
      print("Error checking for sign in");
      return false;
    }
  }
}
