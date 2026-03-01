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
