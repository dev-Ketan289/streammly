import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart'; // adjust path if needed

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'My Wallet',
          style: TextStyle(
            color: Color(0xFF2864A6),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: GetBuilder<AuthController>(
        builder: (authController) {
          final double? wallet = authController.userProfile?.wallet?.toDouble();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                /// Show image only when wallet is null or zero
                if (wallet == null || wallet == 0) ...[
                  Image.asset(
                    'assets/images/wallet.png',
                    width: screenWidth * 0.5,
                    height: screenWidth * 0.5,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Streammly Money',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add Money to enjoy one-tap, streamline payments',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ] else ...[
                  const Text(
                    'Your Wallet Balance',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '₹${wallet.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2864A6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Add your "Add Money" logic or navigation here
                    },
                    child: const Text(
                      'Add Money',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Important Update',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Effective 1st July 2025, Streammly money can be used only pay for available balance atleast 200 in wallet',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Transaction History',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTransactionTab('All Transactions', isActive: true),
                      const SizedBox(width: 8),
                      _buildTransactionTab('Additions'),
                      const SizedBox(width: 8),
                      _buildTransactionTab('Deductions'),
                      const SizedBox(width: 8),
                      _buildTransactionTab('Refunds'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // You can add transaction list here later.
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionTab(String text, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? const Color(0xFF2864A6) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: isActive ? const Color(0xFF2864A6) : Colors.black54,
        ),
      ),
    );
  }
}
