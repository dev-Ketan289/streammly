import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/models/vendors/recommanded_vendors.dart';

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
                          Navigator.pop(context);
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
