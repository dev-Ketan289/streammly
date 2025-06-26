// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';

// import '../../../../../controllers/booking_form_controller.dart';

// class PackageCard extends StatelessWidget {
//       final int index;
//     final String title;
//     final String subtitle;
//     final int price;
//     final bool showLocationDetails;
//     final VoidCallback onEdit;
//     final VoidCallback onToggleDetails;
//   const PackageCard({super.key, required this.index, required this.title, required this.subtitle, required this.price, required this.showLocationDetails, required this.onEdit, required this.onToggleDetails});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<BookingFormController>(
//       builder: (bookingController) {
//         return Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: const Color(0xFFB5B6B7)),
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 title,
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               Text(
//                                 subtitle,
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   color: Color(0xFF2864A6),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             const SizedBox(width: 8),
//                             Text(
//                               '₹$price/-',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w700,
//                                 color: Color(0xFF2864A6),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             GestureDetector(
//                               onTap: onToggleDetails,
//                               child: Icon(
//                                 showLocationDetails
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                                 color: Colors.black,
//                                 size: 20,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             GestureDetector(
//                               onTap: onEdit,
//                               child: const Icon(
//                                 Icons.edit,
//                                 color: Colors.black,
//                                 size: 20,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                   ],
//                 ),
//               ),
        
//               if (showLocationDetails) ...[
//                 Container(height: 1, color: const Color(0xFFB5B6B7)),
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Shoot Location',
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         bookingController.selectedPackages[index]['address'] ??
//                             '1st Floor, Hiren Industrial Estate, 104 & 105 - B, Mogul Ln, Mahim West, Maharashtra 400016.',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.black54,
//                           height: 1.4,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       if (packageTitle == 'Cuteness')
//                         Text(
//                           'Baby Info: ${form['babyInfo'] ?? 'Not set'}',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.black54,
//                           ),
//                         ),
//                       if (packageTitle == 'Moments') ...[
//                         Text(
//                           'Theme: ${form['theme'] ?? 'Not set'}',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Outfit Changes: ${form['outfitChanges'] ?? 'Not set'}',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.black54,
//                           ),
//                         ),
//                       ],
//                       if (packageTitle == 'Wonders')
//                         Text(
//                           'Location Preference: ${form['locationPreference'] ?? 'Not set'}',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.black54,
//                           ),
//                         ),
//                       const SizedBox(height: 16),
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF8F9FA),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: const Color(0xFFE9ECEF)),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   const Text(
//                                     'Date of Shoot',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
        
//                                   Text(
//                                     form['date']?.toString() ?? 'Not set',
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               height: 40,
//                               width: 1,
//                               color: Colors.grey.shade300,
//                               padding: const EdgeInsets.symmetric(horizontal: 14),
//                             ),
//                             SizedBox(width: 5),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   const Text(
//                                     'Timing',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     '${form['startTime']?.toString() ?? 'Not set'} - ${form['endTime']?.toString() ?? 'Not set'}',
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         );
//       }
//     );
//   }
// }