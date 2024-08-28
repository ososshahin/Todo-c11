import 'dart:core';


class AppUser{
  String? authID;
  String? fullname;
  String? email;

  AppUser({this.email, this.authID, this.fullname});

  AppUser.fromFirestore(Map<String,dynamic>?data):
      this.fullname = data?['fullName'],
      this.authID = data?['AuthId'],
     this.email = data?['email'];

  Map<String,dynamic>tofirestore(){
    return { 'fullName':fullname,
      'AuthId':authID,
      'email': email

    };
  }


}