import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<String> getCurrentUser();
  Future<String> getUserName();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    // TODO: only save email if it hasn't been set before (although this does work correctly)
    Firestore.instance.collection('users').document(user.uid).updateData({'email': email});
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    Firestore.instance.collection('users').document(user.uid).setData({'email': email});
    return user.uid;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if(user == null) {
      return null;
    } else {
      return user.uid;
    }
  }

  Future<String> getUserName() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if(user == null) {
      return null;
    } else {
      return user.email;
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
