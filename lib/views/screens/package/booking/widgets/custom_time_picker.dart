import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:streammly/controllers/booking_form_controller.dart';

class CustomTimePicker extends StatefulWidget {
  final bool isStart;
  final bool is24HourFormat;
  final Function(String) onTimeSelected;
  final Function()? onCancel;

  const CustomTimePicker({
    super.key,
    required this.isStart,
    required this.onTimeSelected,
    this.onCancel,
    this.is24HourFormat = false,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late int hour;
  int minute = DateTime.now().minute;
  String amPm = DateTime.now().hour >= 12 ? 'PM' : 'AM';

  @override
  void initState() {
    super.initState();
    if (widget.is24HourFormat) {
      hour = DateTime.now().hour;
    } else {
      int rawHour = DateTime.now().hour;
      hour = rawHour % 12 == 0 ? 12 : rawHour % 12;
    }
  }

  Widget _buildPickerColumn() {
    return GetBuilder<BookingController>(
      builder: (bookingController) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCupertinoPicker(
              hour,
              widget.is24HourFormat
                  ? List.generate(24, (index) => index)
                  : List.generate(12, (index) => index + 1),
              (value) => setState(() {
                hour = widget.is24HourFormat ? value : value + 1;
              }),
              isHour: true,
            ),
            _buildCupertinoPicker(
              minute,
              List.generate(60, (index) => index),
              (value) => setState(() {
                minute = value;
              }),
              isMin: true,
            ),
            if (!widget.is24HourFormat)
              _buildCupertinoPicker(
                amPm == 'AM' ? 0 : 1,
                ['AM', 'PM'],
                (value) => setState(() {
                  amPm = value == 0 ? 'AM' : 'PM';
                }),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCupertinoPicker(
    int selectedValue,
    List values,
    Function(int) onSelectedItemChanged, {
    bool isHour = false,
    bool isMin = false,
  }) {
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
              return GetBuilder<BookingController>(
                builder: (bookingController) {
                  bool isAvailable = false;
                  if (isHour && !bookingController.hours.contains(val)) {
                    isAvailable = true;
                  }
                  if (isMin && !bookingController.minutes.contains(val)) {
                    isAvailable = true;
                  }
                  return Center(
                    child: Text(
                      val is int
                          ? val.toString().padLeft(2, '0')
                          : val.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        color: isAvailable ? Colors.red : Colors.black,
                      ),
                    ),
                  );
                },
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
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "Start",
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ),
                Container(width: 1, color: Colors.grey.shade300),
                Expanded(
                  child: Center(
                    child: Text(
                      "End",
                      style: TextStyle(fontSize: 16, color: Colors.red),
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
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        String formattedTime;

                        if (widget.is24HourFormat) {
                          formattedTime =
                              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
                        } else {
                          // No conversion – just use selected hour and am/pm
                          final displayHour = hour == 0 ? 12 : hour;
                          formattedTime =
                              '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $amPm';
                        }

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
