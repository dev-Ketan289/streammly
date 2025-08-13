import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferAndEarnPage extends StatelessWidget {
  const ReferAndEarnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    const referralCode = "PIK2000";
    const referralLink = "https://streammly.com/referral/$referralCode";

    // Dynamic social icons data with real functionality
    final socialPlatforms = [
      // {
      //   'iconPath': "assets/images/socail_media/facebook.png",
      //   'label': "Facebook",
      //   'action': () => _shareToFacebook(context, referralCode, referralLink),
      // },
      {
        'iconPath': "assets/images/socail_media/whatsapp.png",
        'label': "WhatsApp",
        'action': () => _shareToWhatsApp(context, referralCode, referralLink),
      },
      {
        'iconPath': "assets/images/socail_media/mail.png",
        'label': "Mail",
        'action': () => _shareViaEmail(context, referralCode, referralLink),
      },
      {
        'iconPath': "assets/images/socail_media/link.png",
        'label': "Link",
        'action': () => _copyLink(context, referralLink),
      },
    ];

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
              'assets/images/Referafriend.png',
              height: 250,
              width: 390,
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
                    child: Text(
                      "Code : $referralCode",
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _copyCode(context, referralCode),
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

            // Dynamic Social Icons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  socialPlatforms.map((platform) {
                    return _socialIcon(
                      platform['iconPath'] as String,
                      platform['label'] as String,
                      platform['action'] as VoidCallback,
                    );
                  }).toList(),
            ),

            const SizedBox(height: 24),

            // Dotted Border Box with Steps (keeping your existing code)
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
                        text:
                            "Invite your friend to book a service using your referral link.",
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
                        text:
                            "Your friend completes a booking worth ₹4000 or more.",
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
                        text:
                            "You get ₹2500 off on your next package once their shoot is completed.",
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

  Widget _socialIcon(String iconPath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            child: Image.asset(iconPath, height: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _stepItem({required String iconPath, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(iconPath, height: 28, width: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 14, height: 1.5)),
        ),
      ],
    );
  }

  // Real sharing functionality methods
  // Updated sharing methods with better error handling
  Future<void> _shareToWhatsApp(
    BuildContext context,
    String referralCode,
    String referralLink,
  ) async {
    const String message =
        "Hey! Join Streammly using my referral code: PIK2000 and get amazing discounts on photography services! Download here: ";
    final String fullMessage = message + referralLink;

    try {
      // Try WhatsApp app first
      final String whatsappUrl =
          "whatsapp://send?text=${Uri.encodeComponent(fullMessage)}";
      final Uri whatsappUri = Uri.parse(whatsappUrl);

      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri);
        return;
      }

      // Fallback to web WhatsApp
      final String webWhatsapp =
          "https://wa.me/?text=${Uri.encodeComponent(fullMessage)}";
      final Uri webUri = Uri.parse(webWhatsapp);

      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return;
      }

      // Last fallback - use Share.share
      SharePlus.instance.share(
        ShareParams(text: fullMessage, subject: "Join Streammly!"),
      );
    } catch (e) {
      debugPrint("WhatsApp share error: $e");
      // Fallback to system sharing
      SharePlus.instance.share(
        ShareParams(text: fullMessage, subject: "Join Streammly!"),
      );
    }
  }

  // Future<void> _shareToFacebook(
  //   BuildContext context,
  //   String referralCode,
  //   String referralLink,
  // ) async {
  //   try {
  //     // Simple share - Facebook app will handle it automatically
  //     const String message =
  //         "Check out Streammly! Use my referral code PIK2000 for great discounts on photography services.";
  //
  //     // Use Share.share instead of direct Facebook URL for better compatibility
  //     Share.share("$message\n$referralLink", subject: "Join Streammly!");
  //   } catch (e) {
  //     debugPrint("Facebook share error: $e");
  //     _showErrorSnackbar(context, "Could not share to Facebook");
  //   }
  // }

  Future<void> _shareViaEmail(
    BuildContext context,
    String referralCode,
    String referralLink,
  ) async {
    const String subject = "Join Streammly with my referral code!";
    const String body = """Hi there!

I wanted to share something awesome with you. I've been using Streammly for photography services and they're fantastic!

Use my referral code: PIK2000 when you sign up and you'll get great discounts.

You can download the app here: """;

    final String fullBody = body + referralLink;

    try {
      final String emailUrl =
          "mailto:?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(fullBody)}";
      final Uri emailUri = Uri.parse(emailUrl);

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        // Fallback to system sharing
        SharePlus.instance.share(ShareParams(text: fullBody, subject: subject));
      }
    } catch (e) {
      debugPrint("Email share error: $e");
      // Fallback to system sharing
      SharePlus.instance.share(ShareParams(text: fullBody, subject: subject));
    }
  }

  void _copyLink(BuildContext context, String referralLink) {
    try {
      Clipboard.setData(ClipboardData(text: referralLink));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Referral Link Copied!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint("Copy link error: $e");
      _showErrorSnackbar(context, "Could not copy link");
    }
  }

  void _copyCode(BuildContext context, String referralCode) {
    try {
      Clipboard.setData(ClipboardData(text: referralCode));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Referral Code Copied!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint("Copy code error: $e");
      _showErrorSnackbar(context, "Could not copy code");
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
