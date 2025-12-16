import 'package:flutter/material.dart';
import 'package:quickpalo/widgets/custom_chip_selection.dart';

class TimeSelector extends StatefulWidget {
  const TimeSelector({super.key, required this.timeSlots});
  final List<String> timeSlots;

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  int selectedTime = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.timeSlots.length, (index) {
          return CustomChipSelection(
            label: widget.timeSlots[index],
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
