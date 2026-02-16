import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickpalo/core/widgets/custom_chip_selection.dart';

class DateSelector extends StatefulWidget {
  final Function(DateTime)? onDateSelected;

  const DateSelector({super.key, this.onDateSelected});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int selectedDate = 0;
  late List<DateTime> dates; // Use DateTime list directly

  @override
  void initState() {
    super.initState();
    _generateDates();
  }

  void _generateDates() {
    dates = [];
    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      dates.add(now.add(Duration(days: i)));
    }
  }

  String _getDisplayLabel(DateTime date, int index) {
    if (index == 0) {
      return 'Today\n${date.day}';
    } else if (index == 1) {
      return 'Tom\n${date.day}';
    } else {
      return '${DateFormat('E').format(date)}\n${date.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            DateFormat('MMMM yyyy').format(dates.first),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(dates.length, (index) {
              final date = dates[index];

              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: CustomChipSelection(
                  label: _getDisplayLabel(date, index),
                  isSelected: selectedDate == index,
                  onTap: () {
                    setState(() {
                      selectedDate = index;
                    });

                    if (widget.onDateSelected != null) {
                      widget.onDateSelected!(date);
                    }

                    print(
                        'Selected: ${DateFormat('EEEE, MMMM d, yyyy').format(date)}');
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
