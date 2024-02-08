class ToDoModel {
  String? date;
  String? task;
  bool isCompleted = false;
  // ToDoModel(this.date, this.tssk, this.isCompleted);
  ToDoModel(String date, String task) {
    this.date = date;
    this.task = task;
  }
}
