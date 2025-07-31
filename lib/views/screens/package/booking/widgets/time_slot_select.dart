import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/booking_form_controller.dart';
import 'package:streammly/services/theme.dart';

class TimeSlotSelector extends StatefulWidget {
  final BuildContext context;
  final List<TimeOfDay?> slots;
  final String packageHours;
  final int index;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Function(TimeOfDay? startTime, TimeOfDay? endTime) onSlotSelected;
  const TimeSlotSelector({
    super.key,
    required this.context,
    required this.slots,
    required this.packageHours,
    required this.index,
    this.startTime,
    this.endTime,
    required this.onSlotSelected,
  });

  @override
  State<TimeSlotSelector> createState() => _TimeSlotSelectorState();
}

class _TimeSlotSelectorState extends State<TimeSlotSelector> {
  TimeOfDay? tempStartTime;
  TimeOfDay? tempEndTime;
  int maxDurationInMinutes = 0;

  int convertTimeToMinutes(String packageHours) {
    packageHours = packageHours.replaceAll(RegExp(r'[\[\]]'), '').toLowerCase();
    final hourMatch = RegExp(r'(\d+)\s*hr').firstMatch(packageHours);
    final minMatch = RegExp(r'(\d+)\s*min').firstMatch(packageHours);
    int hours = hourMatch != null ? int.parse(hourMatch.group(1)!) : 0;
    int minutes = minMatch != null ? int.parse(minMatch.group(1)!) : 0;
    return hours * 60 + minutes;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tempStartTime = widget.startTime;
      tempEndTime = widget.endTime;
      maxDurationInMinutes = convertTimeToMinutes(widget.packageHours);
    });
  }

  void onTimeSlotTap(TimeOfDay timeSlot) {
    if (tempStartTime == timeSlot || tempEndTime == timeSlot) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "Start time and end time cannot be the same.",
        toastLength: Toast.LENGTH_LONG,
      );
      setState(() {
        tempStartTime = null;
        tempEndTime = null;
      });
    } else if (tempStartTime == null) {
      setState(() {
        tempStartTime = timeSlot;
      });
    } else if (tempEndTime == null) {
      if (TimeCalculations.isTimeBeforeOrEqual(timeSlot, tempStartTime!)) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: "End time must be after start time.",
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() {
          tempEndTime = null;
          tempStartTime = null;
        });
      } else {
        setState(() {
          tempEndTime = timeSlot;
        });
      }
    } else {
      setState(() {
        tempStartTime = timeSlot;
        tempEndTime = null;
      });
    }

    if (tempStartTime != null && tempEndTime != null) {
      final duration = int.parse(TimeCalculations.calculateDuration(tempStartTime!, tempEndTime!));
      if (duration > maxDurationInMinutes) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: "Selected duration exceeds package limit (${(maxDurationInMinutes / 60).toStringAsFixed(1)} hours). Extra charges will apply.",
          toastLength: Toast.LENGTH_LONG,
        );
      } else if (duration < maxDurationInMinutes) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: "Please select a minimum of ${(maxDurationInMinutes / 60).toStringAsFixed(1)} hours.",
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() {
          tempStartTime = null;
          tempEndTime = null;
        });
      } else {
        widget.onSlotSelected(tempStartTime, tempEndTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.70,
      child: GetBuilder<BookingController>(
        builder: (bookingController) {
          if (bookingController.startTime.isEmpty) {
            return const Center(
              child: Text(
                'No time slots available for the selected date.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Select Time Slot',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (bookingController.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(80),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: widget.slots.length,
                          itemBuilder: (context, slotIndex) {
                            final timeSlot = widget.slots[slotIndex];
                            if (timeSlot == null) return const SizedBox.shrink();
                            final isSelected = timeSlot == tempStartTime || timeSlot == tempEndTime;
                            final isInRange = tempStartTime != null && tempEndTime != null &&
                              TimeCalculations.isTimeBeforeOrEqual(timeSlot, tempEndTime!) &&
                              TimeCalculations.isTimeAfterOrEqual(timeSlot, tempStartTime!);

                            return GestureDetector(
                              onTap: () => onTimeSlotTap(timeSlot),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: isSelected ? primaryColor : isInRange ? Colors.blue[100] : Colors.grey.shade300,
                                  border: Border.all(
                                    color: isSelected ? Colors.blue.shade100 : Colors.grey.shade300,
                                    width: isSelected ? 4.0 : 2.0,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    timeSlot.format(context),
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  if (!bookingController.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                              decoration: BoxDecoration(
                                color: tempStartTime != null ? Colors.blue[50] : Colors.white,
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text("START TIME", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: tempStartTime != null ? Colors.blue[700] : Colors.grey, fontWeight: FontWeight.bold)),
                                  const Divider(),
                                  Text(tempStartTime?.format(context) ?? 'Select start time', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: tempStartTime != null ? Colors.black87 : Colors.grey, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                              decoration: BoxDecoration(
                                color: tempEndTime != null ? Colors.blue[50] : Colors.white,
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text("END TIME", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: tempEndTime != null ? Colors.blue[700] : Colors.grey, fontWeight: FontWeight.bold)),
                                  const Divider(),
                                  Text(tempEndTime?.format(context) ?? 'Select end time', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: tempEndTime != null ? Colors.black87 : Colors.grey, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (tempStartTime != null && tempEndTime != null)
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        () {
                          final minutes = int.parse(TimeCalculations.calculateDuration(tempStartTime!, tempEndTime!));
                          final hrs = minutes ~/ 60;
                          final min = minutes % 60;
                          if (hrs > 0 && min > 0) return '$hrs hr $min min';
                          if (hrs > 0) return '$hrs hr';
                          return '$min min';
                        }(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: tempStartTime != null && tempEndTime != null
                        ? () {
                            widget.onSlotSelected(tempStartTime, tempEndTime);
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(300, 50),
                      backgroundColor: tempStartTime != null && tempEndTime != null ? primaryColor : Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                    ),
                    child: const Text('Confirm'),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class TimeCalculations {
  static String calculateDuration(TimeOfDay startTime, TimeOfDay endTime) {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final durationMinutes = endMinutes - startMinutes;
    return durationMinutes.toString();
  }

  static bool isTimeAfterOrEqual(TimeOfDay time, TimeOfDay reference) {
    return time.hour > reference.hour || (time.hour == reference.hour && time.minute >= reference.minute);
  }

  static bool isTimeBeforeOrEqual(TimeOfDay time, TimeOfDay reference) {
    return time.hour < reference.hour || (time.hour == reference.hour && time.minute <= reference.minute);
  }
}

List<TimeOfDay?> convertSlots(List<dynamic> apiSlots) {
  return apiSlots.map((slot) {
    if (slot['startTime'] != null) {
      final parts = slot['startTime'].split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
    }
    return null;
  }).toList();
}
