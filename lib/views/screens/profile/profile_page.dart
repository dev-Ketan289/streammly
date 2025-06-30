import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streammly/generated/assets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
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
          Container(
            height: 60,
            width: 392,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(''), // replace with your asset
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "UMA RAJPUT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 32,
                  width: 88,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFFFE49C)),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Display SVG asset as a widget
                      SvgPicture.asset(
                        Assets.svgDiamond,
                        height: 11,
                        width: 11,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "Upgrade",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          buildSectionTitle("Profile & Settings"),
          buildTile(Icons.language, "Language Preferences"),
          buildTile(Icons.notifications, "Notification"),
          buildTile(Icons.chat_bubble_outline, "Chat"),
          buildTile(Icons.link, "Linked Accounts"),

          const SizedBox(height: 24),
          buildSectionTitle("Bookings & Orders"),
          buildTile(Icons.book_online, "My Bookings"),
          buildTile(Icons.cancel_outlined, "Cancellation History"),

          const SizedBox(height: 24),
          buildSectionTitle("Offers & Wishlist"),
          buildTile(Icons.local_offer_outlined, "Saved Offers"),
          buildTile(Icons.favorite_border, "WishList"),

          const SizedBox(height: 24),
          buildSectionTitle("Payments & Wallet"),
          buildTile(Icons.account_balance_wallet, "My Wallet"),
          buildTile(Icons.receipt_long, "Transaction History"),
          buildTile(Icons.receipt, "Invoice"),
          buildTile(Icons.redeem, "Refer & Earn"),
          buildTile(Icons.percent, "Apply Promo Code"),
        ],
      ),
    );
  }

  // List tile widget
  Widget buildTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Colors.white,
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        onTap: () {},
      ),
    );
  }

  // Section header
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
