import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_c11/Database/Collections/TasksCollection.dart';
import 'package:todo_c11/DialogUtils.dart';
import 'package:todo_c11/ui/common/addTaskBottomSheet.dart';
import 'package:todo_c11/ui/editTask/EditTaskScreen.dart';
import 'package:todo_c11/ui/utils.dart';

import '../../../Database/models/task.dart';
import 'package:todo_c11/DateTimeUtils.dart';

import '../../../providers/appauthprovider.dart';
import '../../../providers/taskProvider.dart';
typedef onTaskDeleteClick = Function(Task task);
class TaskItem extends StatefulWidget {
  Task task;
  onTaskDeleteClick onDeleteClick;



  TaskItem({required this.task, required this.onDeleteClick});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {

  @override


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, EditTaskScreen.routeName,
      arguments: ScreenArguments(widget.task)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: Slidable(
          startActionPane: ActionPane(
            motion: DrawerMotion(),
            children: [
              SlidableAction(onPressed: (buildContext) {
                showMessageDialog(context, 'Are you sure to delete the task?',
                    posButtonTitle: 'Confirm', posButtonAction: () {
                  Navigator.pop(context);
                     widget.onDeleteClick(widget.task );

                    },
                    negButtonTitle: 'cancel', negButtonAction: () {
                      Navigator.pop(context);
                    });
              },
                icon: Icons.delete,
                backgroundColor: Colors.red,
                label: 'delete',
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              )
            ],
          ),
          child: Card(

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24
              ),
              child: Row(
                children: [
                  Container(width: 4, height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:widget.task.isDone?Colors.green:
                        Theme
                            .of(context)
                            .primaryColor,)
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.task.title!,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium?.copyWith(
                                color: widget.task.isDone?Colors.green:
                                    Colors.blue
                              ),
                            ),
                            SizedBox(height: 8,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.watch_later_outlined),
                                SizedBox(width: 8,),
                                Text(widget.task.time!.formatTime(),
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall,
                                )

                              ],)
                          ]
                      )),
                  SizedBox(width: 12,),
                  InkWell(
                    onTap: () {
                      widget.task.isDone?null:
                      MakeTaskDone();
                    },
                    child:widget.task.isDone?
                        Text('Done',style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium?.copyWith(color: Colors.green),):
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24,
                          vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ImageIcon(
                        AssetImage(getImagePath('ic_check.png'),),
                        color: Colors.white,
                      ),),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  MakeTaskDone()async {

     widget.task.isDone=true;
      var taskProvider = Provider.of<TasksProvider>(context,listen: false);
      var authProvider = Provider.of<AppAuthProvider>(context,listen: false);
      try{
        showLoadingDialog(context, 'Updating Task pleae wait...');
        await taskProvider.updateTasktoDone(authProvider.AuthUser?.uid??'', widget.task);
        hideLoadingDialog(context);

        ;}
      catch(e){
        hideLoadingDialog(context);
        showMessageDialog(context, 'Something went wrong',
          posButtonTitle: 'Try again',posButtonAction: () {
          MakeTaskDone();
          },);

      }}

  }



class ScreenArguments{
  Task task;
  ScreenArguments(this.task);
}