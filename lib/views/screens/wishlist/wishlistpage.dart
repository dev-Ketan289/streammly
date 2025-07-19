import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/wishlist_controller.dart';
import 'package:streammly/views/screens/home/widgets/category/widgets/recommended_vendor_card.dart';
import 'package:streammly/models/vendors/recommanded_vendors.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final wishlistController = Get.find<WishlistController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      wishlistController.loadBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Wishlist',
          style: TextStyle(
            color: Color(0xFF2864A6),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GetBuilder<WishlistController>(
          builder: (controller) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.bookmarks.isEmpty) {
              return const Center(
                child: Text(
                  "No items in your wishlist.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.bookmarks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: RecommendedVendorCard(
                    itemWidth: 100,
                    theme: Theme.of(context),
                    wishlistController: wishlistController,
                    onTap: () {
                      Get.bottomSheet(
                        WishlistBottomSheet(
                          vendor: controller.bookmarks[index],
                          onRemove: () async {
                            final result = await wishlistController.addBookmark(
                              controller
                                  .bookmarks[index]
                                  .id, // or the correct ID field
                              "vendor", // or the correct type
                            );
                            if (result.isSuccess) {
                              Get.snackbar(
                                'Removed',
                                'Item removed from wishlist',
                              );
                            } else {
                              Get.snackbar('Error', result.message);
                            }
                          },
                        ),
                      );
                    },
                    vendor: controller.bookmarks[index],
                    imageUrl: controller.bookmarks[index].bannerImage ?? '',
                    rating: controller.bookmarks[index].rating.toString(),
                    companyName: controller.bookmarks[index].companyName ?? '',
                    category: controller.bookmarks[index].companyType ?? '',
                    time: controller.bookmarks[index].longitude ?? '',
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class WishlistBottomSheet extends StatefulWidget {
  final RecommendedVendors vendor;
  final Future<void> Function() onRemove;

  const WishlistBottomSheet({
    Key? key,
    required this.vendor,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<WishlistBottomSheet> createState() => _WishlistBottomSheetState();
}

class _WishlistBottomSheetState extends State<WishlistBottomSheet> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Remove from Wishlist',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Are you sure you want to remove this?',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Removing this will delete it from your saved Wishlist.'),
            SizedBox(height: 24),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.blue.shade700),
                  ),
                ),
                onPressed:
                    _isLoading
                        ? null
                        : () async {
                          setState(() => _isLoading = true);
                          await widget.onRemove();
                          setState(() => _isLoading = false);
                          Get.back();
                        },
                child:
                    _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                          'Yes, Remove',
                          style: TextStyle(color: Colors.blue[700]),
                        ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                onPressed: _isLoading ? null : () => Get.back(),
                child: Text(
                  'Keep Wishlist',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
