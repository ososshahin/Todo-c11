class Task{
  String? id;
  String? title;
  String? description;
  int? date;
  int? time;
  bool isDone;

  Task({this.title, this.time, this.date, this.description, this.id,
    this.isDone= false});
  Task.fromFirestore(Map<String,dynamic>?data):
      this(id: data?['id'],title: data?['title'],
      description: data?['description'],date: data?['date'],
      time: data?['time'],
      isDone: data?['isDone']);
  Map<String,dynamic>toFireStore(){
    return {'id':id,
      'title':title,
      'description':description,
      'date':date,
      'time':time,
      'isDone':isDone};

  }

}