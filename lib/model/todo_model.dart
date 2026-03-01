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
}
