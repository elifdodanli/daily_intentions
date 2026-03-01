/// Represents the status filters available for the task list.
enum TodoFilter { all, active, completed }

// The data model for a to-do item
class TodoModel {
  String id;
  String title;
  bool isCompleted;
  DateTime createdAt;

  TodoModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
  });

  /// CONVERT TO JSON (Serialization)
  /// Translates our Dart object into a simple Map so it can be saved.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      // Dates cannot be saved directly, so we convert them to a standard String format
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// BUILD FROM JSON (Deserialization)
  /// Takes the simple Map from the hard drive and reconstructs our Dart object.
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      // We parse the String back into a real DateTime object
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
