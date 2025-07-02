import 'package:flutter/material.dart';
import 'package:streammly/views/screens/profile/components/profile_section_widget.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: const Text(
          "Notification",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2864A6),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ProfileSectionWidget(title: "New"),
          ReminderCard(
            icon: Icons.calendar_today,
            title: 'Reminder. ',
            message: 'Get ready for your appointment at 9am',
            time: '11.32 PM',
            date: 'Just Now',
          ),
        ],
      ),
    );
  }
}

class ReminderCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final String date;
  const ReminderCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular background with calendar icon
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),

          // Message and time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                        text: title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: message),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 5),
          // Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              Text(
                time,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget buildNotificationCard({
//   required IconData icon,
//   required String title,
//   required String message,
//   required String time,
//   required String date,
// }) {
//   return Container(
//     padding: const EdgeInsets.all(12),
//     margin: const EdgeInsets.only(bottom: 12),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.blue.shade50,
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, size: 20, color: Colors.blue),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               RichText(
//                 text: TextSpan(
//                   text: title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: ' . $message',
//                       style: const TextStyle(fontWeight: FontWeight.normal),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 children: [
//                   Text(
//                     time,
//                     style: const TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                   const Spacer(),
//                   Text(
//                     date,
//                     style: const TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// class SectionTitle extends StatelessWidget {
//   final String title;

//   const SectionTitle({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 15,
//         color: Colors.black54,
//       ),
//     );
//   }
// }
