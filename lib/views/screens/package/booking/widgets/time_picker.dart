import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final bool isStart; // Determines if picking start or end time
  final Function(String) onTimeSelected; // Callback to return selected time
  final Function()? onCancel;
  const CustomTimePicker({
    super.key,
    required this.isStart,
    required this.onTimeSelected,
    this.onCancel,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  int hour = DateTime.now().hour % 12 == 0 ? 12 : DateTime.now().hour % 12;
  int minute = DateTime.now().minute;
  String amPm = DateTime.now().hour >= 12 ? 'PM' : 'AM';

  Widget _buildPickerColumn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCupertinoPicker(
          hour,
          List.generate(12, (index) => index + 1),
          (value) => setState(() {
            hour = value + 1;
          }),
        ),
        _buildCupertinoPicker(
          minute,
          List.generate(60, (index) => index),
          (value) => setState(() {
            minute = value;
          }),
        ),
        _buildCupertinoPicker(
          amPm == 'AM' ? 0 : 1,
          ['AM', 'PM'],
          (value) => setState(() {
            amPm = value == 0 ? 'AM' : 'PM';
          }),
        ),
      ],
    );
  }

  Widget _buildCupertinoPicker(
    int selectedValue,
    List values,
    Function(int) onSelectedItemChanged,
  ) {
    return SizedBox(
      width: 80,
      height: 150,
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: values.indexOf(selectedValue),
        ),
        selectionOverlay: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade300),
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        itemExtent: 32,
        onSelectedItemChanged: onSelectedItemChanged,
        children:
            values.map<Widget>((val) {
              return Center(
                child: Text(
                  val is int ? val.toString().padLeft(2, '0') : val.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(16), // Circular border radius
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "Start",
                      style: TextStyle(
                        fontSize: 16, // Match font size of Set/Cancel
                        color: Colors.blue, // Match color of Set
                      ),
                    ),
                  ),
                ),
                Container(width: 1, color: Colors.grey.shade300), // Divider
                Expanded(
                  child: Center(
                    child: Text(
                      "End",
                      style: TextStyle(
                        fontSize: 16, // Match font size of Set/Cancel
                        color: Colors.red, // Match color of Cancel
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildPickerColumn()),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(16), // Circular border radius
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        // Format the time to match TimeOfDay.format (e.g., "9:30 AM")
                        final formattedTime =
                            '${hour == 12 && amPm == 'AM'
                                ? 0
                                : hour == 12 && amPm == 'PM'
                                ? 12
                                : hour}:${minute.toString().padLeft(2, '0')} ${amPm}';
                        widget.onTimeSelected(formattedTime);
                      },
                      child: const Text(
                        "Set",
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                Container(width: 1, color: Colors.grey.shade300),
                Expanded(
                  child: Center(
                    child: TextButton(
                      onPressed: widget.onCancel,
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
