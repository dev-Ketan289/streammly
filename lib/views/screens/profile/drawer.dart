import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/auth_controller.dart'; // Added
import 'package:streammly/generated/assets.dart';
import 'package:streammly/views/screens/profile/components/profile_section_widget.dart';
import 'package:streammly/views/screens/profile/language_preferences.dart';
import 'package:streammly/views/screens/profile/linked_pages.dart';
import 'package:streammly/views/screens/profile/notifications_page.dart';
import 'package:streammly/views/screens/profile/offers_page.dart';
import 'package:streammly/views/screens/profile/profile_screen.dart';

import 'components/profile_item_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
            Get.back();
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
                    radius: screenWidth * 0.06, // Responsive radius
                    backgroundImage: const AssetImage(
                      '',
                    ), // You can update later with profile image
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: Text(
                      authController.isLoggedIn()
                          ? authController.userProfile?.name ?? ""
                          : 'Login / Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
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
              Get.to(() => NotificationsPage());
            },
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgBell, height: 26, width: 26),
            title: "Chat",
            onTap: () {},
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
            icon: SvgPicture.asset(Assets.svgMybookings, height: 26, width: 26),
            title: "My Bookings",
            onTap: () {},
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(
              Assets.svgCancellation,
              height: 26,
              width: 26,
            ),
            title: "Cancellation History",
            onTap: () {},
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
            onTap: () {},
          ),

          SizedBox(height: screenHeight * 0.03),
          ProfileSectionWidget(title: "Payments & Wallet"),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgSaved, height: 26, width: 26),
            title: "My Wallet",
            onTap: () {},
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(
              Assets.svgTransaction,
              height: 26,
              width: 26,
            ),
            title: "Transaction History",
            onTap: () {},
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(
              Assets.svgTransaction,
              height: 26,
              width: 26,
            ),
            title: "Invoice",
            onTap: () {},
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgRefer, height: 26, width: 26),
            title: "Refer & Earn",
            onTap: () {},
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgPromo, height: 26, width: 26),
            title: "Apply Promo Code",
            onTap: () {},
          ),
          SizedBox(height: screenHeight * 0.03),

          ProfileSectionWidget(title: "Rating & Reviews"),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgRate, height: 26, width: 26),
            title: "Rate your Experience",
            onTap: () {},
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
            onTap: () {},
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgReport, height: 26, width: 26),
            title: "Report an Issue",
            onTap: () {},
          ),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgWorks, height: 26, width: 26),
            title: "How it Works",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
