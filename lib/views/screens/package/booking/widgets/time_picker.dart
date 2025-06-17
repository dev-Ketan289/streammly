import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<TimeOfDay?> showCustomTimePicker(BuildContext context, TimeOfDay initialTime) {
  FixedExtentScrollController hourController = FixedExtentScrollController(initialItem: initialTime.hour);
  FixedExtentScrollController minuteController = FixedExtentScrollController(initialItem: initialTime.minute);
  FixedExtentScrollController amPmController = FixedExtentScrollController(initialItem: initialTime.period == DayPeriod.am ? 0 : 1);

  int selectedHour = initialTime.hour;
  int selectedMinute = initialTime.minute;
  String selectedPeriod = initialTime.period == DayPeriod.am ? "AM" : "PM";

  return showModalBottomSheet<TimeOfDay>(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Text("Pick Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Divider(),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPicker(hourController, List.generate(12, (i) => i + 1), (value) => selectedHour = value),
                const SizedBox(width: 8),
                _buildPicker(minuteController, List.generate(60, (i) => i), (value) => selectedMinute = value),
                const SizedBox(width: 8),
                _buildPicker(amPmController, ["AM", "PM"], (value) => selectedPeriod = value),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(child: Text("Cancel"), onPressed: () => Navigator.pop(context)),
              ElevatedButton(
                child: Text("Set"),
                onPressed: () {
                  if (selectedPeriod == "PM" && selectedHour < 12) selectedHour += 12;
                  if (selectedPeriod == "AM" && selectedHour == 12) selectedHour = 0;
                  Navigator.pop(context, TimeOfDay(hour: selectedHour, minute: selectedMinute));
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

Widget _buildPicker(FixedExtentScrollController controller, List options, Function(dynamic) onSelected) {
  return Expanded(
    child: CupertinoPicker(
      scrollController: controller,
      itemExtent: 40,
      onSelectedItemChanged: (index) => onSelected(options[index]),
      children: options.map<Widget>((e) => Center(child: Text(e.toString().padLeft(2, '0')))).toList(),
    ),
  );
}
