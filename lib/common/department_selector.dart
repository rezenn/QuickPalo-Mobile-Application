import 'package:flutter/material.dart';
import 'package:quickpalo/widgets/custom_chip_selection.dart';

class DepartmentSelector extends StatefulWidget {
  final List<String> departments;

  const DepartmentSelector({super.key, required this.departments});

  @override
  State<DepartmentSelector> createState() => _DepartmentSelectorState();
}

class _DepartmentSelectorState extends State<DepartmentSelector> {
  int selectedDept = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.departments.length, (index) {
          return CustomChipSelection(
            label: widget.departments[index],
            isSelected: selectedDept == index,
            onTap: () {
              setState(() => selectedDept = index);
            },
          );
        }),
      ),
    );
  }
}
