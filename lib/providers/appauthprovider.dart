

import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/material.dart';
import 'package:todo_c11/Database/models/AppUser.dart';
import 'package:todo_c11/ui/register/RegisterScreen.dart';

import '../Database/Collections/UserCollections.dart';


class AppAuthProvider extends ChangeNotifier{
  User? AuthUser;
   UserCollections? user= UserCollections();
   AppUser? appUser;
  AppAuthProvider(){
      AuthUser = FirebaseAuth.instance.currentUser;
      if(AuthUser!=null){
        signInWithUid(AuthUser!.uid);
        notifyListeners();};

  }
   void login(User newuser){
    AuthUser = newuser;
   }
   void logout(BuildContext context){
    AuthUser = null;
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
   }
   bool isLoggedin(){
    return AuthUser!=null;
   }

  Future<AppUser?> createAccountWithEmailAndPassword(
       String email,
       String password,
      String fullName
       )async{
     final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
         email: email,
         password: password,);
     if(credential.user!=null){
       login(credential.user!);

     appUser= AppUser(authID: credential.user?.uid,email: email, fullname: fullName);
    var result= await user?.CreateUser(appUser!);
     return appUser;}
     return null;
   }
   Future<AppUser?> signInWithEmailAndPassword(
       String email,
       String password
       )async{
     final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
     if(credential.user!=null){
       login(credential.user!);
       appUser= await user?.readUser(credential.user!.uid);
     }

     return appUser;
   }
   signInWithUid(String uid)async{
     appUser= await user?.readUser(uid);
   }
}