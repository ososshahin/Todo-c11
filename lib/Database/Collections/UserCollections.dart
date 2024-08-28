import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_c11/Database/models/AppUser.dart';

class UserCollections{
  CollectionReference<AppUser>getUserCollection(){
    var  db = FirebaseFirestore.instance;
   return db.collection('users')
        .withConverter(fromFirestore: (snapshot, options) {
      return AppUser.fromFirestore(snapshot.data());
    },
      toFirestore: (value, options) {
        return value.tofirestore();
      },);
  }
 Future<void>  CreateUser(AppUser user){
    return getUserCollection().doc(user.authID).set(user);

}

  Future<AppUser?> readUser(String uid) async{
   var doc= getUserCollection().doc(uid);
   var docSnapshot =  await doc.get();
   return docSnapshot.data();
  }

}