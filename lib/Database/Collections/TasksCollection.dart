import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_c11/Database/models/task.dart';

class Taskscollection{
  CollectionReference<Task>
  getTaskscollection(String userId){
   var db = FirebaseFirestore.instance;
   return db.collection('users').doc(userId).collection('tasks')
       .withConverter(
       fromFirestore: (snapshot, options) {
         return Task.fromFirestore(snapshot.data());
       },
       toFirestore: (task, options) {
         return task.toFireStore();
       });

  }
  Future<void>addTask(String userId,Task task){
   var docRef= getTaskscollection(userId).doc();
   task.id=docRef.id;
   return docRef.set(task);
  }
  Future<List<Task>>  getTaskLists(String userId)async{
   var querySnapshot= await getTaskscollection(userId).get();
  var tasklist= querySnapshot.docs.map((DocumentSnapshot) => DocumentSnapshot.data()).toList();
  return tasklist;
  }

  Future<void> removeTask(String userId,Task task) {
   var docRef=  getTaskscollection(userId).doc(task.id);
   return docRef.delete();
  }
  Future<void>updateTask(String userId,Task task, {String? newTitle,
    String? newDescription, int? Time, int? Date,
    }){
    var docRef = getTaskscollection(userId).doc(task.id);
     return docRef.update( { 'title':newTitle,
    'description':newDescription,
   'time':Time,
    'date':Date});
  }Future<void>updateTasktoDone(String userId,Task task,

    ){
    var docRef = getTaskscollection(userId).doc(task.id);
     return docRef.update( { 'isDone':true
    });
  }

}
