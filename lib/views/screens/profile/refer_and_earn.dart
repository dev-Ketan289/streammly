import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferAndEarnPage extends StatelessWidget {
  const ReferAndEarnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    const referralCode = "PIK2000";

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black87),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          "Refer & Earn",
          style: textTheme.titleMedium?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Image.asset(
              'assets/images/Refer a friend.png',
              height: 200,
            ),
            const SizedBox(height: 20),

            // Referral Code with Copy Functionality
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text("Code : $referralCode", style: textTheme.bodyMedium),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(const ClipboardData(text: referralCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Referral Code Copied!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      "Copy Code",
                      style: textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Invite Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Invite",
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Social Icons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _socialIcon("assets/images/socail_media/facebook.png", "Facebook"),
                _socialIcon("assets/images/socail_media/whatsapp.png", "WhatsApp"),
                _socialIcon("assets/images/socail_media/mail.png", "Mail"),
                _socialIcon("assets/images/socail_media/link.png", "Link"),
              ],
            ),

            const SizedBox(height: 24),

            // Dotted Border Box with Steps
            DottedBorder(
              options: const RoundedRectDottedBorderOptions(
                dashPattern: [8, 4],
                strokeWidth: 1.5,
                color: Colors.blue,
                radius: Radius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12), 
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _stepItem(
                        iconPath: 'assets/images/socail_media/link.png',
                        text: "Invite your friend to book a service using your referral link.",
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/images/socail_media/leftarrow.png',
                          height: 40,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _stepItem(
                        iconPath: 'assets/images/socail_media/box.png',
                        text: "Your friend completes a booking worth ₹4000 or more.",
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/images/socail_media/rightarrow.png',
                          height: 40,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _stepItem(
                        iconPath: 'assets/images/socail_media/wallet.png',
                        text: "You get ₹2500 off on your next package once their shoot is completed.",
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(String iconPath, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey.shade200,
          child: Image.asset(iconPath, height: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _stepItem({required String iconPath, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(iconPath, height: 28, width: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
      ],
    );
  }
}
