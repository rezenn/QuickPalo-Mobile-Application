import 'package:flutter/material.dart';
import 'package:quickpalo/core/widgets/custom_chip_selection.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';

class DepartmentSelector extends StatefulWidget {
  final List<DepartmentEntity> departments;
  final Function(DepartmentEntity) onDepartmentSelected;

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
  void initState() {
    super.initState();
    if (widget.departments.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onDepartmentSelected(widget.departments[0]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.departments.length, (index) {
          final dept = widget.departments[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CustomChipSelection(
              label: dept.name,
              isSelected: selectedDept == index,
              onTap: () {
                setState(() {
                  selectedDept = index;
                });
                widget.onDepartmentSelected(dept);
              },
            ),
          );
        }),
      ),
    );
  }
}
