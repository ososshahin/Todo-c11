

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:todo_c11/Database/Collections/TasksCollection.dart';
import 'package:todo_c11/Database/models/task.dart';
import 'package:todo_c11/DialogUtils.dart';
import 'package:todo_c11/providers/appauthprovider.dart';
import 'package:todo_c11/providers/taskProvider.dart';
import 'package:todo_c11/ui/common/DateTimeFormField.dart';
import 'package:todo_c11/ui/common/TaskFormField.dart';
import 'package:todo_c11/DateTimeUtils.dart';
class addTaskBottomSheet extends StatefulWidget{
  @override
  State<addTaskBottomSheet> createState() => _addTaskBottomSheetState();
}

class _addTaskBottomSheetState extends State<addTaskBottomSheet> {
  var formKey = GlobalKey<FormState>();
  TextEditingController? title =TextEditingController();
  TextEditingController? description= TextEditingController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(12),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TaskFormField(validator: (text){
              if(text==null||text.trim().isEmpty){
                return'Enter task name';
              }
            }, hint: 'write name of task', title: 'Task Name',  controller: title,),
            TaskFormField( validator: (text) {
              if(text==null||text.trim().isEmpty){
                return'Enter task description';
              }},hint: 'write task descrption', title: 'Task Description',
             lines: 3,controller: description,),
            SizedBox(height: 12,),
            Row(
              children: [
                Expanded(child: DateTimeFormField(title:
                    'Task date',hint:selectedDate==null? 'Set Date':
                  '${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}',onclick: () {
                  showDatePickerDialog(context);
                },  )),
                SizedBox(width: 4,),
                Expanded(child: DateTimeFormField(title:'Task time',hint:  selectedTime==null? 'Set Time':
                '${selectedTime?.hour}:${selectedTime?.minute} ',
                onclick:  () {
                  showTimePickerDialog(context);
                },)),
              ],
            ),
            ElevatedButton(onPressed: () {
               addTask();
            }, child:
            Text('Add task'))
          ],
        ),
      ),
    );
  }
DateTime? selectedDate;
  void showDatePickerDialog(BuildContext context) async{
   var date = await showDatePicker(context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),initialDate:selectedDate==null?DateTime.now():selectedDate);

   setState(() {
     selectedDate = date;
   });
  }
  TimeOfDay? selectedTime;
  void showTimePickerDialog(BuildContext context)async {
    var time= await showTimePicker(context: context,
       initialTime: selectedTime??TimeOfDay.now()
        );
    setState(() {
      selectedTime = time;
    });

  }
bool isValid(){
    bool isValid = true;
  if(formKey.currentState?.validate()==false){
    isValid =false;
  }
  if(selectedDate==null){
    showMessageDialog(context, 'Select task date',posButtonTitle: 'ok',
      posButtonAction: () => Navigator.pop(context),);
    isValid = false;
  } if(selectedTime==null){
    showMessageDialog(context, 'Select task time',posButtonTitle: 'ok',
      posButtonAction:() => Navigator.pop(context),);
    isValid = false;
  }return isValid;
}
  void addTask()async {

    if(isValid==false)return;

    var authProvider =Provider.of<AppAuthProvider>(context,listen: false);
     var taskProvider =Provider.of<TasksProvider>(context,listen: false);
     var task = Task(
       title: title?.text,
       description: description?.text,
       date: selectedDate?.DateOnly(),
       time: selectedTime?.timeOnly(),

     );

      try{
        showLoadingDialog(context, 'Adding task please wait..');
        var result = await taskProvider.addTask(task, authProvider.AuthUser!.uid??'',);

        hideLoadingDialog(context);
        showMessageDialog(context, 'Task added successfully',posButtonTitle: 'ok',
        posButtonAction: () {
          Navigator.pop(context);
        },);
      }catch(e){
        showMessageDialog(context, e.toString());
      }


  }


}
