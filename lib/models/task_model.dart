// ignore_for_file: non_constant_identifier_names

class TaskModel {
  final int task_id;
  final String task_name;
  final String task_category;
  final String task_category_color;
  final String task_description;
  final DateTime task_createdAt;
  final DateTime task_dueDate;
  final DateTime? task_completedDate; // completed date can be nullable
  bool task_isCompleted = false;

  TaskModel({
    required this.task_id,
    required this.task_name,
    required this.task_category,
    required this.task_category_color,
    required this.task_description,
    required this.task_createdAt,
    required this.task_dueDate,
    this.task_completedDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      task_id: json['id'] ?? 0,
      task_name: json['name'] ?? "not-found",
      task_category: json['category'] ?? "not-found",
      task_category_color: json['category_color'] ?? "0xFF808080",
      task_description: json['description'] ?? "not-found",
      task_createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) as DateTime
          : DateTime.fromMillisecondsSinceEpoch(0),
      task_dueDate: json['due_date'] != null
          ? DateTime.tryParse(json['due_date'].toString()) as DateTime
          : DateTime.fromMillisecondsSinceEpoch(0),
      task_completedDate: json['completed_date'] != null
          ? DateTime.tryParse(json['completed_date'].toString()) as DateTime
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
