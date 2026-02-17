import 'package:flutter/material.dart';
import 'package:quickpalo/core/widgets/custom_chip_selection.dart';

class DepartmentSelector extends StatefulWidget {
  final List<String> departments;
  final Function(String) onDepartmentSelected;

  const DepartmentSelector({
    super.key,
    required this.departments,
    required this.onDepartmentSelected,
  });

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
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CustomChipSelection(
              label: widget.departments[index],
              isSelected: selectedDept == index,
              onTap: () {
                setState(() {
                  selectedDept = index;
                });
                widget.onDepartmentSelected(widget.departments[index]);
              },
            ),
          );
        }),
      ),
    );
  }
}