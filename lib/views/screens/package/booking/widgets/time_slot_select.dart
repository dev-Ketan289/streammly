// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:streammly/models/package/slots_model.dart';

// class SlotSelectionSheet extends StatefulWidget {
//   final List<Slot> slots;
//   final int minimumDuration;
//   final void Function(Slot start, Slot end) onSelected;

//   const SlotSelectionSheet({
//     super.key,
//     required this.slots,
//     required this.minimumDuration,
//     required this.onSelected,
//   });

//   @override
//   State<SlotSelectionSheet> createState() => _SlotSelectionSheetState();
// }

// class _SlotSelectionSheetState extends State<SlotSelectionSheet> {
//   Slot? selectedStart;
//   Slot? selectedEnd;

//   DateTime _parse(String time) {
//     return DateFormat("HH:mm").parse(time);
//   }

//   int _durationInMinutes(Slot start, Slot end) {
//     // final s = _parse(start.startTime);
//     // final e = _parse(end.endTime);
//     return e.difference(s).inMinutes;
//   }

//   bool _isBeforeOrSame(Slot a, Slot b) =>
//       // _parse(a.startTime).isBefore(_parse(b.startTime)) || a.startTime == b.startTime;

//   void _onTap(Slot tappedSlot) {
//     if (!tappedSlot.isAvailable) return;

//     if (selectedStart == null) {
//       setState(() => selectedStart = tappedSlot);
//     } else if (selectedEnd == null) {
//       if (_isBeforeOrSame(tappedSlot, selectedStart!)) {
//         setState(() {
//           selectedStart = tappedSlot;
//           selectedEnd = null;
//         });
//       } else {
//         final duration = _durationInMinutes(selectedStart!, tappedSlot);
//         if (duration < widget.minimumDuration) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Minimum ${widget.minimumDuration} minutes required")),
//           );
//         } else {
//           setState(() => selectedEnd = tappedSlot);
//         }
//       }
//     } else {
//       setState(() {
//         selectedStart = tappedSlot;
//         selectedEnd = null;
//       });
//     }
//   }

//   bool _isInRange(Slot slot) {
//     if (selectedStart == null || selectedEnd == null) return false;
//     // final s = _parse(slot.startTime);
//     // return s.isAfter(_parse(selectedStart!.startTime)) &&
//     //        s.isBefore(_parse(selectedEnd!.startTime));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final slots = widget.slots;

//     return Padding(
//       padding: MediaQuery.of(context).viewInsets,
//       child: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Select Time Slot", style: Theme.of(context).textTheme.titleLarge),
//               const SizedBox(height: 12),
//               GridView.builder(
//                 shrinkWrap: true,
//                 itemCount: slots.length,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   childAspectRatio: 2.8,
//                   crossAxisSpacing: 8,
//                   mainAxisSpacing: 8,
//                 ),
//                 itemBuilder: (_, i) {
//                   final slot = slots[i];
//                   final isSelected = selectedStart == slot || selectedEnd == slot;
//                   final inRange = _isInRange(slot);
//                   final color = !slot.isAvailable
//                       ? Colors.grey[300]
//                       : isSelected
//                           ? Colors.deepPurple
//                           : inRange
//                               ? Colors.purple[100]
//                               : Colors.white;

//                   return GestureDetector(
//                     onTap: () => _onTap(slot),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: color,
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "${slot.startTime} - ${slot.endTime}",
//                           style: TextStyle(
//                             color: slot.isAvailable ? Colors.black : Colors.grey,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: selectedStart != null && selectedEnd != null
//                     ? () {
//                         widget.onSelected(selectedStart!, selectedEnd!);
//                         Navigator.pop(context);
//                       }
//                     : null,
//                 child: const Text("Done"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
