import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension onlyDate on DateTime{

 int DateOnly(){
   var newDate = DateTime(
     year,month,day
   );
   return newDate.millisecondsSinceEpoch;
 }
 formatDate(){
   DateFormat dateFormat = DateFormat("yyyy-MM-dd");
   return dateFormat.format(this);
 }
}
extension onlyTime on TimeOfDay{
  int timeOnly(){
    var newTime = DateTime(
      0,0,0,this.hour,this.minute
    );
    return newTime.millisecondsSinceEpoch;
  }
  formatTime(){
    DateFormat dateFormat = DateFormat("HH:mm");
   return dateFormat.format(DateTime(0,0,0,hour,minute));
  }

}
extension dateFormat on int{
  formatDate(){
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(this));
  }
  formatTime(){
    DateFormat dateFormat = DateFormat("HH:mm");
    return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(this));
  }
}