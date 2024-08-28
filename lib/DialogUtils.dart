import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showMessageDialog(BuildContext context, String message,
    {String? posButtonTitle,
    VoidCallback? posButtonAction,
    String? negButtonTitle,
    VoidCallback? negButtonAction,
    bool isCancelable = true}) {
  List<Widget> actions = [];
  if (posButtonTitle != null) {
    actions.add(
        TextButton(onPressed: posButtonAction, child: Text(posButtonTitle)));
  }
  if (negButtonTitle != null) {
    actions.add(
        TextButton(onPressed: negButtonAction, child: Text(negButtonTitle)));
  }
  showDialog(
    barrierDismissible: isCancelable,
    context: context,
    builder: (context) => AlertDialog(
      content: Text(message),
      actions: actions,
    ),
  );
}

showLoadingDialog(BuildContext context, String message,{bool isCancelable = true}) {
  showDialog(
    barrierDismissible:isCancelable,
    context: context,
    builder: (context) => AlertDialog(
      actions: [Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 10,),
          Text(message,style: TextStyle(fontSize: 20),),])
        ],
      ),

    );
}
hideLoadingDialog(BuildContext context){
  Navigator.pop(context);
}
