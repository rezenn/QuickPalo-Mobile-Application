import 'package:flutter/material.dart';
import 'package:quickpalo/widgets/custom_chip_selection.dart';

class OrganizationFilter extends StatefulWidget {
  const OrganizationFilter({super.key});

  @override
  State<OrganizationFilter> createState() => _OrganizationFilterState();
}

class _OrganizationFilterState extends State<OrganizationFilter> {
  int selectedDate = 0;

  final dates = [
    "All",
    "Hospital",
    "Bank",
    "Service Center",
    "University",
    "School",
    "College",
    "Government Office",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(dates.length, (index) {
          return CustomChipSelection(
            label: dates[index],
            // hasBorder: true,
            isSelected: selectedDate == index,
            onTap: () {
              setState(() => selectedDate = index);
            },
          );
        }),
      ),
    );
  }
}
