

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerece_flutter_app/common/popups/full_screen_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';


class AuthService {

  //dang ki acc
    Future<String> createAccountWithEmail(String email, String password, String name)async{
      try{
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
         User? user = userCredential.user;

        // add lên firestore
       if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "uid": user.uid,
           "name": name,
          "email": email,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

        return 'Account Created';
      }
      on FirebaseAuthException catch(e){
        return e.message.toString();
      }
    }
// dang nhap
    Future<String> loginWithEmail(String email, String password)async{
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        return 'Login Successfull';
      }on FirebaseAuthException catch(e){
         return e.message.toString();
      }
    }
// dang xuat
    Future logout()async{
      await FirebaseAuth.instance.signOut();
    }

    Future<bool> isLoggedIn()async{
      var user  = FirebaseAuth.instance.currentUser;
      return user != null;
    }

    Future<Map<String, dynamic>?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      return snapshot.data() as Map<String, dynamic>?;
    }
    return null;
  }
}