import 'package:flutter/material.dart';
import 'package:todo_c11/Database/Collections/TasksCollection.dart';
import 'package:todo_c11/Database/models/task.dart';

class TasksProvider extends ChangeNotifier{
  var tasksCollection = Taskscollection();

  Future<List<Task>> getTasksList(String userId){
   var taskslist= tasksCollection.getTaskLists(userId);

    return taskslist;
  }
 Future<void> addTask(Task task,String userId)async{
  await  tasksCollection.addTask(userId, task);
    notifyListeners();
    return;
  }
  Future<void>deleteTask(Task task,String userId)async{
   await tasksCollection.removeTask(userId, task);
    notifyListeners();
    return;


  }
  Future<void>updateTask(String userId,Task task, {String? newTitle,
    String? newDescription, int? Time, int? Date,
    })async{
     await tasksCollection.updateTask(userId, task,
    newTitle: newTitle,newDescription: newDescription,
    Time: Time,Date: Date);
   notifyListeners();
   return;
  }

  updateTasktoDone(String userId,Task task)async{
    await tasksCollection.updateTasktoDone(userId, task);
    notifyListeners();
    return;
  }
}