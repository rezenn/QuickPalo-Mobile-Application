import 'package:flutter/material.dart';
import 'package:quickpalo/core/widgets/custom_chip_selection.dart';

class TimeSelector extends StatefulWidget {
  final List<String> timeSlots;
  final Function(String) onTimeSelected;

  const TimeSelector({
    super.key,
    required this.timeSlots,
    required this.onTimeSelected,
  });

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
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CustomChipSelection(
              label: widget.timeSlots[index],
              isSelected: selectedTime == index,
              onTap: () {
                setState(() {
                  selectedTime = index;
                });
                widget.onTimeSelected(widget.timeSlots[index]);
              },
            ),
          );
        }),
      ),
    );
  }
}