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
import 'package:streammly/views/screens/profile/profile_screen.dart';

import 'components/profile_item_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>(); // Added

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
        title: const Text('Profile', style: TextStyle(color: Color(0xFF2864A6), fontSize: 20, fontWeight: FontWeight.bold)),
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
              height: 60,
              width: 392,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.blue[800], borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(''), // You can update later with profile image
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      authController.isLoggedIn()
                          ? 'UMA RAJPUT' // You can later replace with actual name after API
                          : 'Login / Register',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (authController.isLoggedIn()) // Show Upgrade button only if logged in
                    Container(
                      height: 32,
                      width: 88,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(border: Border.all(color: Color(0xFFFFE49C)), color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(Assets.svgDiamond, height: 11, width: 11),
                          const SizedBox(width: 4),
                          const Text("Upgrade", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
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
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgBell, height: 26, width: 26), title: "Chat", onTap: () {}),
          ProfileItemWidget(
            icon: SvgPicture.asset(Assets.svgLinked, height: 26, width: 26),
            title: "Linked Accounts",
            onTap: () {
              Get.to(() => LinkedPages());
            },
          ),

          const SizedBox(height: 24),
          ProfileSectionWidget(title: "Bookings & Orders"),
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgMybookings, height: 26, width: 26), title: "My Bookings", onTap: () {}),
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgCancellation, height: 26, width: 26), title: "Cancellation History", onTap: () {}),

          const SizedBox(height: 24),
          ProfileSectionWidget(title: "Offers & Wishlist"),
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgSaved, height: 26, width: 26), title: "Saved Offers", onTap: () {}),
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgSaved, height: 26, width: 26), title: "WishList", onTap: () {}),

          const SizedBox(height: 24),
          ProfileSectionWidget(title: "Payments & Wallet"),
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgSaved, height: 26, width: 26), title: "My Wallet", onTap: () {}),
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgTransaction, height: 26, width: 26), title: "Transaction History", onTap: () {}),
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgTransaction, height: 26, width: 26), title: "Invoice", onTap: () {}),
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgRefer, height: 26, width: 26), title: "Refer & Earn", onTap: () {}),
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgPromo, height: 26, width: 26), title: "Apply Promo Code", onTap: () {}),
          const SizedBox(height: 24),

          ProfileSectionWidget(title: "Rating & Reviews"),
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgRate, height: 26, width: 26), title: "Rate your Experience", onTap: () {}),
          const SizedBox(height: 24),

          ProfileSectionWidget(title: "Help & Support"),
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgChat, height: 26, width: 26), title: "Chat with Support", onTap: () {}),
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgFaq, height: 26, width: 26), title: "FAQ's", onTap: () {}),
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgReport, height: 26, width: 26), title: "Report an Issue", onTap: () {}),
          ProfileItemWidget(icon: SvgPicture.asset(Assets.svgWorks, height: 26, width: 26), title: "How it Works", onTap: () {}),
        ],
      ),
    );
  }
}
