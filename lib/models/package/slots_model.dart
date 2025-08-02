import 'package:flutter/material.dart';

class Slot {
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final bool booked;
  final bool breakTime;
  final bool blockHome;
  final bool blockIndoor;
  final bool blockOutdoor;

  Slot({
     this.startTime,
     this.endTime,
    required this.booked,
    required this.breakTime,
    required this.blockHome,
    required this.blockIndoor,
    required this.blockOutdoor,
  });

  bool get isAvailable =>
      !booked && !breakTime && !blockHome && !blockIndoor && !blockOutdoor;

  factory Slot.fromJson(Map<String?, dynamic> json) {
    return Slot(
      startTime: json['start_time'] != null ? TimeOfDay(
        hour: int.parse(json['start_time'].split(":")[0]),
        minute: int.parse(json['start_time'].split(":")[1]),
      ) : null,
      endTime: json['end_time'] != null ? TimeOfDay(
        hour: int.parse(json['end_time'].split(":")[0]),
        minute: int.parse(json['end_time'].split(":")[1]),
      ) : null,   
      booked: json['booked'] ?? true,
      breakTime: json['break'] ?? true,
      blockHome: json['block_homeshoot_time'] ?? true,
      blockIndoor: json['block_indoorshoot_time'] ?? true,
      blockOutdoor: json['block_outdoorshoot_time'] ?? true,
    );
  }
}

class SlotMananger {
  final int hour;
  final int minute;
  final bool isAvailable;
  SlotMananger({
    required this.hour,
    required this.minute,
    required this.isAvailable,
  });
}
