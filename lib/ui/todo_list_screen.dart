import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/constants/colors.dart';
import '../model/todo_model.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoModel> myTodos = [];
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // CORE LOGIC: Add Task
  void _addNewTask() {
    if (_titleController.text.trim().isEmpty) return;

    final newTask = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      createdAt: DateTime.now(),
    );

    setState(() {
      myTodos.add(newTask);
    });

    _titleController.clear();
    Navigator.pop(context);
  }

  // CORE LOGIC: Delete Task
  void _deleteTask(String id) {
    setState(() {
      myTodos.removeWhere((todo) => todo.id == id);
    });
  }

  // UI: Task Card with Swipe-to-Delete
  Widget _buildTaskCard(TodoModel todo, int index) {
    return Dismissible(
      key: Key(todo.id), // Unique key for Dismissible
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _deleteTask(todo.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          onLongPress: () =>
              _showTaskBottomSheet(existingTodo: todo), // Edit on long press
          leading: IconButton(
            icon: Icon(
              todo.isCompleted
                  ? Icons.auto_awesome
                  : Icons.radio_button_unchecked,
              color: Colors.pink[200],
            ),
            onPressed: () {
              setState(() => todo.isCompleted = !todo.isCompleted);
            },
          ),
          title: Text(
            todo.title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: kTextGrey,
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }

  // UI: Bottom Sheet for Adding/Editing Tasks
  void _showTaskBottomSheet({TodoModel? existingTodo}) {
    // if we have an existingTodo, we are in edit mode, otherwise we are adding a new task
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
            // Task title
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

                // State management for both adding and editing tasks
                setState(() {
                  if (existingTodo != null) {
                    // Update the existing task's title
                    existingTodo.title = _titleController.text;
                  } else {
                    // Add a new task to the list
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
              // Button text changes based on whether we're adding or editing
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
            Expanded(
              child: myTodos.isEmpty
                  ? Center(
                      child: Text(
                        "No tasks yet... Start blooming! ✨",
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: myTodos.length,
                      itemBuilder: (context, index) {
                        return _buildTaskCard(myTodos[index], index);
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
