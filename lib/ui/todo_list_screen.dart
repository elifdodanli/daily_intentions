import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/constants/colors.dart';
import 'package:to_do_app/model/todo_model.dart';
import 'package:to_do_app/ui/widgets/aesthetic_task_card.dart';
import 'package:to_do_app/ui/widgets/filter_chips_row.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoModel> myTodos = [];
  final TextEditingController _titleController = TextEditingController();
  TodoFilter currentFilter = TodoFilter.all;

  /// Returns a temporary list of tasks based on the [currentFilter].
  /// This ensures the original [myTodos] list is never accidentally modified or deleted.
  List<TodoModel> get filteredTodos {
    switch (currentFilter) {
      case TodoFilter.active:
        return myTodos.where((todo) => !todo.isCompleted).toList();
      case TodoFilter.completed:
        return myTodos.where((todo) => todo.isCompleted).toList();
      case TodoFilter.all:
      default:
        return myTodos;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _deleteTask(String id) {
    setState(() {
      myTodos.removeWhere((todo) => todo.id == id);
    });
  }

  void _showTaskBottomSheet({TodoModel? existingTodo}) {
    if (existingTodo != null) {
      _titleController.text = existingTodo.title;
    } else {
      _titleController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kCreamIvory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 25,
          right: 25,
          top: 25,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              existingTodo != null ? "Edit Intention" : "New Intention",
              style: GoogleFonts.cormorantGaramond(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Task Title",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.trim().isEmpty) return;

                setState(() {
                  if (existingTodo != null) {
                    existingTodo.title = _titleController.text;
                  } else {
                    final newTask = TodoModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _titleController.text,
                      createdAt: DateTime.now(),
                    );
                    myTodos.add(newTask);
                  }
                });

                _titleController.clear();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kMarshmallowPink,
                foregroundColor: kTextGrey,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                existingTodo != null ? "Update Intention" : "Add to Plan",
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemsToShow = filteredTodos;

    return Scaffold(
      backgroundColor: kCreamIvory,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Daily Planner',
          style: GoogleFonts.cormorantGaramond(
            color: kTextGrey,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 20),
              child: Text(
                "Today's Intentions",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  letterSpacing: 1.5,
                  color: Colors.grey,
                ),
              ),
            ),

            FilterChipsRow(
              currentFilter: currentFilter,
              onFilterChanged: (newFilter) {
                setState(() {
                  currentFilter = newFilter;
                });
              },
            ),
            const SizedBox(height: 15),
            Expanded(
              child: itemsToShow.isEmpty
                  ? Center(
                      child: Text(
                        "No tasks yet... Start blooming! ✨",
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemsToShow.length,
                      itemBuilder: (context, index) {
                        final currentTodo = itemsToShow[index];

                        return AestheticTaskCard(
                          todo: currentTodo,
                          onDelete: () => _deleteTask(currentTodo.id),
                          onLongPress: () =>
                              _showTaskBottomSheet(existingTodo: currentTodo),
                          onToggle: () {
                            setState(() {
                              currentTodo.isCompleted =
                                  !currentTodo.isCompleted;
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 176, 202),
        elevation: 2,
        onPressed: _showTaskBottomSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
