import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/auth_controller.dart'; // Added
import 'package:streammly/generated/assets.dart';
import 'package:streammly/services/route_helper.dart';
import 'package:streammly/views/screens/package/booking/my_bookings.dart';
import 'package:streammly/views/screens/profile/about_page.dart';
import 'package:streammly/views/screens/profile/components/profile_section_widget.dart';
import 'package:streammly/views/screens/profile/faq_page.dart';
import 'package:streammly/views/screens/profile/invoice_screen.dart';
import 'package:streammly/views/screens/profile/language_preferences.dart';
import 'package:streammly/views/screens/profile/linked_pages.dart';
import 'package:streammly/views/screens/profile/my_quotation.dart';
import 'package:streammly/views/screens/profile/my_wallet.dart';
import 'package:streammly/views/screens/profile/offers_page.dart';
import 'package:streammly/views/screens/profile/profile_screen.dart';
import 'package:streammly/views/screens/profile/rate_your_experience.dart';
import 'package:streammly/views/screens/profile/refer_and_earn.dart';
import 'package:streammly/views/screens/profile/report_us.dart';
import 'package:streammly/views/screens/profile/settings.dart';
import 'package:streammly/views/screens/profile/support_screen.dart';
import 'package:streammly/views/screens/wishlist/wishlistpage.dart';

import '../../../navigation_flow.dart';
import '../../../services/custom_error_pop_widget.dart';
import 'chatbot_page.dart';
import 'components/profile_item_widget.dart';
import 'components/transcation_histroy_screen.dart';
import 'notifications_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.fetchUserProfile().then((value) {
        if (value?.isSuccess ?? false) {
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>(); // Added
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF2864A6),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          GestureDetector(
            onTap: () {
              if (authController.isLoggedIn()) {
                log("navigating to profile");
                Get.to(() => ProfileScreen());
              } else {
                log("navigating to login");
                Get.toNamed('/login');
              }
            },
            child: Container(
              height: screenHeight * 0.08, // Responsive height
              width: double.infinity, // Take full width
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.01,
              ),
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.06,
                    backgroundImage:
                        authController.userProfile?.profileImage != null &&
                                authController
                                    .userProfile!
                                    .profileImage!
                                    .isNotEmpty
                            ? NetworkImage(
                              authController.userProfile!.profileImage!,
                            )
                            : const AssetImage(Assets.imagesEllipse)
                                as ImageProvider,
                  ),

                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: GetBuilder<AuthController>(
                      builder:
                          (controller) => Text(
                            controller.isLoggedIn()
                                ? controller.userProfile?.name ?? ""
                                : 'Login / Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ),
                  ),
                  if (authController.isLoggedIn())
                    Container(
                      height: screenHeight * 0.04,
                      width: screenWidth * 0.22,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.005,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFFFE49C)),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            Assets.svgDiamond,
                            height: screenWidth * 0.03,
                            width: screenWidth * 0.03,
                          ),
                          Text(
                            "Upgrade",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.03),
          ProfileSectionWidget(title: "Profile & Settings"),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgLanguage, height: 26, width: 26),
            title: "Language Preferences",
            onTap: () {
              Get.to(() => LanguagePreferencesScreen());
            },
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgBell, height: 26, width: 26),
            title: "Notification",
            onTap: () {
              Navigator.push(
                context,
                getCustomRoute(child: NotificationsPage()),
              );
            },
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgBell, height: 26, width: 26),
            title: "Chat",
            onTap: () {
              Navigator.push(context, getCustomRoute(child: ChatbotPage()));
            },
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgLinked, height: 26, width: 26),
            title: "Linked Accounts",
            onTap: () {
              Get.to(() => LinkedPages());
            },
          ),

          SizedBox(height: screenHeight * 0.03),


          ProfileSectionWidget(title: "Bookings & Orders"),

          ProfileItemWidget(
            icon: SvgPicture.asset(
              Assets.svgCancellation,
              height: 26,
              width: 26,
            ),
            title: "My Quotation",
            onTap: () {
              if (authController.isLoggedIn()) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  Get.to(() => MyQuotationScreen());
                });
              } else {
                CommonPopupDialog.show(
                  context,
                  imagePath: 'assets/images/access_denied.png', // your image asset
                  title: "Login Required",
                  message: "Please log in to view your cancellation history.",
                  primaryBtnText: "Login",
                  onPrimaryPressed: () {
                    Get.toNamed('/login');
                  },
                  secondaryBtnText: "Cancel",
                  onSecondaryPressed: () {
                    // nothing extra, just close
                  },
                );
              }
            },
          ),

          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgMybookings, height: 26, width: 26),
            title: "My Bookings",
            onTap: () {
              if (authController.isLoggedIn()) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  Get.to(() => MyBookings());
                });
              } else {
                CommonPopupDialog.show(
                  context,
                  imagePath: 'assets/images/access_denied.png',
                  title: "Login Required",
                  message: "You need to log in to view your bookings.",
                  primaryBtnText: "Login",
                  onPrimaryPressed: () {
                    Get.toNamed('/login'); // Navigate to login
                  },
                  secondaryBtnText: "Cancel",
                  onSecondaryPressed: () {
                    // Just close dialog, nothing else to do
                  },
                );
              }
            },
          ),




          SizedBox(height: screenHeight * 0.03),
          ProfileSectionWidget(title: "Offers & Wishlist"),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgSaved, height: 26, width: 26),
            title: "Saved Offers",
            onTap: () {
              Get.to(() => OffersPage());
            },
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgSaved, height: 26, width: 26),
            title: "WishList",
            onTap: () {
              Navigator.push(context, getCustomRoute(child: WishlistPage()));
            },
          ),

          SizedBox(height: screenHeight * 0.03),
          ProfileSectionWidget(title: "Payments & Wallet"),

// My Wallet
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgSaved, height: 26, width: 26),
            title: "My Wallet",
            onTap: () {
              authController.requireLogin(
                context,
                message: "Please log in to access your wallet.",
                onSuccess: () => Get.to(() => WalletScreen()),
              );
            },
          ),

// Transaction History
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgTransaction, height: 26, width: 26),
            title: "Transaction History",
            onTap: () {
              authController.requireLogin(
                context,
                message: "Please log in to view your transaction history.",
                onSuccess: () => Get.to(() => TransactionHistoryScreen()),
              );
            },
          ),

// Invoice
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgTransaction, height: 26, width: 26),
            title: "Invoice",
            onTap: () {
              authController.requireLogin(
                context,
                message: "Please log in to view your invoices.",
                onSuccess: () => Get.to(() => InvoiceScreen()),
              );
            },
          ),

// Refer & Earn
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgRefer, height: 26, width: 26),
            title: "Refer & Earn",
            onTap: () {
              authController.requireLogin(
                context,
                message: "Please log in to refer and earn rewards.",
                onSuccess: () => Get.to(() => ReferAndEarnPage()),
              );
            },
          ),

// // Apply Promo Code
//           ProfileItemWidget(
//             icon: SvgPicture.asset(Assets.svgPromo, height: 26, width: 26),
//             title: "Apply Promo Code",
//             onTap: () {
//               authController.requireLogin(
//                 context,
//                 message: "Please log in to apply a promo code.",
//                 onSuccess: () {
//                   // Your promo code logic here
//                 },
//               );
//             },
//           ),
          SizedBox(height: screenHeight * 0.03),


          ProfileSectionWidget(title: "Rating & Reviews"),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgRate, height: 26, width: 26),
            title: "Rate your Experience",
            onTap: () {
              Get.to(() => RateExperiencePage());
            },
          ),
          SizedBox(height: screenHeight * 0.03),

          ProfileSectionWidget(title: "Help & Support"),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgChat, height: 26, width: 26),
            title: "Chat with Support",
            onTap: () {},
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgFaq, height: 26, width: 26),
            title: "FAQ's",
            onTap: () {
              Navigator.push(context, getCustomRoute(child: FaqScreen()));
            },
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgReport, height: 26, width: 26),
            title: "Report an Issue",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ReportIssuePage(bookings: [],)));
            },
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgWorks, height: 26, width: 26),
            title: "How it Works",
            onTap: () {},
          ),
          SizedBox(height: screenHeight * 0.03),

          ProfileSectionWidget(title: "More"),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgAbout, height: 26, width: 26),
            title: "About",
            onTap: () {
              Navigator.push(context, getCustomRoute(child: AboutScreen()));
            },
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgSettings, height: 26, width: 26),
            title: "Settings",
            onTap: () {
              Navigator.push(context, getCustomRoute(child: Settings()));
            },
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgSupport, height: 26, width: 26),
            title: "Support",
            onTap: () {
              Get.to(() => SupportTicketPage());
            },
          ),
          if (authController.isLoggedIn())
            ProfileItemWidget(
              icon: SvgPicture.asset(Assets.svgLogout, height: 26, width: 26),
              title: "Logout",
              onTap: () {
                authController.logout(); // Clear data, sign out
                NavigationFlow.navKey.currentState?.switchToTab(0); // Go to Home tab
                Fluttertoast.showToast(msg: "Logged out successfully");
              },
            ),

          SizedBox(height: screenHeight * 0.03),
        ],
      ),
    );
  }
}
