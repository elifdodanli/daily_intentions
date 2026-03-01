import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/constants/colors.dart';
// Import the TodoFilter enum from the model
import 'package:to_do_app/model/todo_model.dart';

// A reusable widget for the filter chips row
class FilterChipsRow extends StatelessWidget {
  final TodoFilter currentFilter;
  final Function(TodoFilter) onFilterChanged;

  const FilterChipsRow({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: TodoFilter.values.map((filter) {
        bool isSelected = currentFilter == filter;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          // Each chip represents a filter option
          child: ChoiceChip(
            label: Text(
              filter.name.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : kTextGrey,
              ),
            ),
            selected: isSelected,
            selectedColor: kMarshmallowPink,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected ? Colors.transparent : Colors.grey.shade300,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (bool selected) {
              onFilterChanged(filter); // Tell the parent the filter changed
            },
          ),
        );
      }).toList(),
    );
  }
}
