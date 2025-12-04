import 'package:flutter/material.dart';
import 'package:quickpalo/widgets/custom_chip_selection.dart';

class DepartmentSelector extends StatefulWidget {
  const DepartmentSelector({super.key});

  @override
  State<DepartmentSelector> createState() => _DepartmentSelectorState();
}

class _DepartmentSelectorState extends State<DepartmentSelector> {
  int selectedDept = 0;

  final departments = [
    "Gynecology",
    "Orthopedics",
    "Pediatrics",
    "Dermatology",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(departments.length, (index) {
          return CustomChipSelection(
            label: departments[index],
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
