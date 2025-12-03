import 'package:flutter/material.dart';
import 'package:quickpalo/widgets/custom_chip_selection.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({super.key});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int selectedDate = 0;

  final dates = ["Sun\n5", "Mon\n6", "Tue\n7", "Wed\n8", "Thu\n9", "Fri\n10"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(dates.length, (index) {
          return CustomChipSelection(
            label: dates[index],
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
