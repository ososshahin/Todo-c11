import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_c11/Database/Collections/TasksCollection.dart';
import 'package:todo_c11/Database/models/task.dart';
import 'package:todo_c11/DialogUtils.dart';
import 'package:todo_c11/providers/appauthprovider.dart';
import 'package:todo_c11/providers/taskProvider.dart';
import 'package:todo_c11/ui/home/list/TaskItem.dart';

class TasksListTab extends StatefulWidget {
  const TasksListTab({super.key});

  @override
  State<TasksListTab> createState() => _TasksListTabState();
}

class _TasksListTabState extends State<TasksListTab> {

 late AppAuthProvider authProvider;
late TasksProvider tasksProvider;
 @override
  void initState() {

    authProvider= Provider.of<AppAuthProvider>(context,listen: false);

  }

  @override
  Widget build(BuildContext context) {
    tasksProvider= Provider.of<TasksProvider>(context,listen: true);
    return FutureBuilder(
        future: tasksProvider.getTasksList(authProvider.AuthUser!.uid??''),
        builder:(context, snapshot) {
          if(snapshot.hasError){
            return Center(
              child:Column(
                children: [
                  Text('Something went wrong'),
                  ElevatedButton(onPressed: () {
                    setState(() {

                    });
                  }, child: Text('Try again'))
                ],
              ) ,
            );
          }if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);

          }
          var taskLists = snapshot.data;
          return  ListView.separated(itemBuilder: (context, index) {
    return TaskItem(task: taskLists[index], onDeleteClick: deleteTask);
    }, separatorBuilder: (_, __) => Container(height: 24,)
    , itemCount: taskLists!.length);
    }

    );}

  deleteTask(Task task)async {
   showLoadingDialog(context, 'deleting task please wait....');
  try{
   await tasksProvider.deleteTask(task,authProvider.AuthUser?.uid??'');
  hideLoadingDialog(context);
  showMessageDialog(context, 'Task deleted successfuly',posButtonTitle: 'ok',
      posButtonAction:() {
        Navigator.pop(context);
      },);

  }catch(e){
    showMessageDialog(context, 'Something went wrong',
        posButtonTitle:'Try again',posButtonAction: () {
          deleteTask(task);
        });

  }

  }

}
