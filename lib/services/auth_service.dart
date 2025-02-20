

import 'package:ecommerece_flutter_app/common/popups/full_screen_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';


class AuthService {
  //dang ki acc
    Future<String> createAccountWithEmail(String email, String password)async{
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
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
}