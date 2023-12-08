class TaskModel {
  int? idTask;
  String? nameTask;
  String? dscTask;
  String? sttTask;
  String? initDate;
  String? endDate;

  TaskModel({this.sttTask, this.idTask, this.nameTask, this.dscTask, this.initDate, this.endDate});
  
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
        idTask: map['idTask'],
        dscTask: map['dscTask'],
        nameTask: map['nameTask'],
        sttTask: map['sttTask'],
        initDate: map['initDate'],
        endDate: map['endDate'],
        );
  }

  Map<String, dynamic> getValuesMap() {
    return {
      'idTask': idTask,
      'nameTask': nameTask,
      'dscTask': dscTask,
      'sttTask': sttTask,
      'initTask': initDate,
      'endTask': endDate,
    };
  }

  DateTime getDateFrom(date) {
    DateTime dt = DateTime.parse(date);
    return dt;
  }
}
