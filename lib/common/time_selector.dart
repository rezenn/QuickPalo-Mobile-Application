import 'package:flutter/material.dart';
import 'package:quickpalo/widgets/custom_chip_selection.dart';

class TimeSelector extends StatefulWidget {
  const TimeSelector({super.key});

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  int selectedTime = 0;

  final times = [
    "9:00 - 10:00",
    "10:00 - 11:00",
    "11:00 - 12:00",
    "12:00 - 13:00",
    "13:00 - 14:00",
    "14:00 - 15:00",
    "15:00 - 16:00",
    "16:00 - 17:00",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(times.length, (index) {
          return CustomChipSelection(
            label: times[index],
            isSelected: selectedTime == index,
            onTap: () {
              setState(() => selectedTime = index);
            },
          );
        }),
      ),
    );
  }
}
