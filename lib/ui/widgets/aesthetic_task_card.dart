import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/model/todo_model.dart';

class AestheticTaskCard extends StatefulWidget {
  final TodoModel todo;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final VoidCallback onLongPress; //  trigger the edit sheet

  const AestheticTaskCard({
    super.key,
    required this.todo,
    required this.onDelete,
    required this.onToggle,
    required this.onLongPress,
  });

  @override
  State<AestheticTaskCard> createState() => _AestheticTaskCardState();
}

class _AestheticTaskCardState extends State<AestheticTaskCard> {
  late bool _isCompletedVisual;

  @override
  void initState() {
    super.initState();
    _isCompletedVisual = widget.todo.isCompleted;
  }

  @override
  // If the parent updates the todo (e.g., from an edit), we need to sync our visual state
  void didUpdateWidget(AestheticTaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.todo.id != widget.todo.id ||
        oldWidget.todo.isCompleted != widget.todo.isCompleted) {
      _isCompletedVisual = widget.todo.isCompleted;
    }
  }

  // Handle the toggle with a visual delay for the animation effect
  void _handleToggle() async {
    setState(() {
      _isCompletedVisual = !_isCompletedVisual;
    });
    await Future.delayed(
      const Duration(milliseconds: 600),
    ); // Wait for 600ms before triggering the parent toggle so the user can see the sparkle animation
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    // Dismissible allows swipe-to-delete functionality
    return Dismissible(
      key: Key(widget.todo.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => widget.onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      // The actual card UI
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
        // ListTile provides a convenient layout for leading icon and title
        child: ListTile(
          onLongPress: widget.onLongPress, // Trigger edit from parent
          leading: IconButton(
            icon: Icon(
              _isCompletedVisual
                  ? Icons.auto_awesome
                  : Icons.radio_button_unchecked,
              color: Colors.pink[200],
            ),
            onPressed: _handleToggle,
          ),

          title: Text(
            widget.todo.title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF5D5D5D),
              decoration: _isCompletedVisual
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
