import 'package:flutter/material.dart';
import 'package:to_do_app/ui/todo_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Hides the debug banner in the top right corner
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const TodoListScreen(),
    );
  }
}
