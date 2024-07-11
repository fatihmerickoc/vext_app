class TaskInfoModel {
  final String id;
  final String type;
  final String name;
  final String description;
  final String color;

  TaskInfoModel({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.color,
  });

  factory TaskInfoModel.fromJson(Map<String, dynamic> json) {
    return TaskInfoModel(
      id: json['id'] ?? "not-found-id",
      type: json['type'] ?? "not-found-type",
      name: json['name'] ?? "not-found-name",
      description: json['description'] ?? "not-found-description",
      color: json['color'] ?? "0xFFDAD8C9",
    );
  }
}
