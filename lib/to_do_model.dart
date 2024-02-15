class ToDoModel {
  int? id;
  String? task;
  String? date;
  int? isCompleted;

  ToDoModel({
    this.id,
    this.task,
    this.date,
    this.isCompleted = 0,
  });

  factory ToDoModel.fromJson(Map<String, dynamic> json) => ToDoModel(
        id: json["id"],
        task: json["task"],
        date: json["date"],
        isCompleted: json["isCompleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "task": task,
        "date": date,
        "isCompleted": isCompleted,
      };
}
