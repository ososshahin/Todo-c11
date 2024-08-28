import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:todo_c11/DialogUtils.dart';
import 'package:todo_c11/providers/appauthprovider.dart';
import 'package:todo_c11/providers/taskProvider.dart';
import 'package:todo_c11/ui/common/DateTimeFormField.dart';
import 'package:todo_c11/ui/common/TaskFormField.dart';
import 'package:todo_c11/DateTimeUtils.dart';
import 'package:todo_c11/ui/home/HomeScreen.dart';

import '../../Database/models/task.dart';
import '../home/list/TaskItem.dart';
class EditTaskScreen extends StatefulWidget {
  static const routeName = 'EditTask';
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}


class _EditTaskScreenState extends State<EditTaskScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('To do List'
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          elevation: 10,
          child: Container(
            width: 350,
            height: 450,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Edit Task', style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 20,),
                TaskFormField(controller: widget.title,
                    title: 'Task title', hint: 'Enter task title'),
                SizedBox(height: 20,),

                TaskFormField(controller: widget.description,
                    title: 'Task desctiption', hint: 'Enter task description'),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(child: DateTimeFormField(title: 'Task date',
                          hint: selectedDate == null ? 'Set Date' :
                          '${selectedDate?.formatDate()}',
                          onclick: () {
                            showDatePickerDialog(context);
                          })),
                      Expanded(child: DateTimeFormField(title: 'Task time',
                          hint: selectedTime == null ? 'Set Time' :
                          '${selectedTime?.formatTime()} ',
                          onclick: () {
                            showTimePickerDialog(context);
                          }))
                    ],
                  ),
                ),
                ElevatedButton(onPressed: () {
                  EditTask(args.task,widget.title.text,widget.description.text);
                }, child: Text('Edit Task'))
              ],

            ),

          ),
        ),
      ),


    );
  }

  DateTime? selectedDate;

  void showDatePickerDialog(BuildContext context) async {
    var date = await showDatePicker(context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
        initialDate: selectedDate == null ? DateTime.now() : selectedDate);

    setState(() {
      selectedDate = date;
    });
  }

  TimeOfDay? selectedTime;

  void showTimePickerDialog(BuildContext context) async {
    var time = await showTimePicker(context: context,
        initialTime: selectedTime ?? TimeOfDay.now()
    );
    setState(() {
      selectedTime = time;
    });
  }


  void EditTask(Task task,String title,String description) async{

    var taskProvider = Provider.of<TasksProvider>(context,listen: false);
    var authProvider = Provider.of<AppAuthProvider>(context,listen: false);
    try{
      showLoadingDialog(context, 'Updating Task pleae wait...');
      await taskProvider.updateTask(authProvider.AuthUser?.uid??"",task,
    Date: selectedDate?.DateOnly(),
    Time: selectedTime?.timeOnly(),
      newTitle: title,newDescription: description);
      hideLoadingDialog(context);

      showMessageDialog(context, 'Task updated successfully',
      posButtonTitle: 'ok',posButtonAction: () {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      },);


  }catch(e){
      hideLoadingDialog(context);
      showMessageDialog(context, 'Something went wrong',
      posButtonTitle: 'Try again',posButtonAction: () {
        EditTask(task, title, description);
      },);

    }
}}