// ignore_for_file: non_constant_identifier_names

class TaskModel {
  String task_title;
  int task_dueDate;
  String task_category;

  TaskModel({
    required this.task_title,
    required this.task_dueDate,
    required this.task_category,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      task_title: json['value'],
      task_dueDate: json['due'],
      task_category: json['value'],
    );
  }
}
