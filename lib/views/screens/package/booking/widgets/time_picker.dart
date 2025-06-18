import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String?> showCustomTimePicker({required BuildContext context, required TimeOfDay initialTime}) async {
  int hour = initialTime.hourOfPeriod;
  int minute = initialTime.minute;
  int period = initialTime.period.index;

  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (_) {
      return SizedBox(
        height: 260,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(12), child: Text("Select Time", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(initialItem: hour),
                      itemExtent: 40,
                      onSelectedItemChanged: (val) => hour = val,
                      children: List.generate(12, (i) => Center(child: Text('${i + 1}'.padLeft(2, '0')))),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(initialItem: minute),
                      itemExtent: 40,
                      onSelectedItemChanged: (val) => minute = val,
                      children: List.generate(60, (i) => Center(child: Text(i.toString().padLeft(2, '0')))),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(initialItem: period),
                      itemExtent: 40,
                      onSelectedItemChanged: (val) => period = val,
                      children: const [Center(child: Text('AM')), Center(child: Text('PM'))],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  TextButton(
                    onPressed: () {
                      final h = period == 1 ? ((hour + 1) % 12 + 12) : ((hour + 1) % 12);
                      final t = TimeOfDay(hour: h, minute: minute).format(context);
                      Navigator.pop(context, t);
                    },
                    child: const Text('Set'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
