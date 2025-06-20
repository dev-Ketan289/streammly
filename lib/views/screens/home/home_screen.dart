import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/home_screen_controller.dart';
import 'package:streammly/controllers/location_controller.dart';
import 'package:streammly/models/banner/banner_item.dart';
import 'package:streammly/models/category/category_item.dart';
import 'package:streammly/views/screens/home/widgets/category/category.dart';
import 'package:streammly/views/screens/home/widgets/category/explore_us.dart';
import 'package:streammly/views/screens/home/widgets/category/page_nav.dart';
import 'package:streammly/views/screens/home/widgets/category/recommended_list.dart';
import 'package:streammly/views/screens/home/widgets/category/widgets/category_scroller.dart';
import 'package:streammly/views/screens/home/widgets/header_banner.dart';
import 'package:streammly/views/screens/home/widgets/promo_slider.dart';
import 'package:streammly/views/screens/home/widgets/upcoming_offer_card.dart';

class HomeScreen extends StatelessWidget {
  final List<String> promoSlider = ["assets/images/category/media.png"];
  final HomeController controller = Get.put(HomeController());
  final LocationController locationController = Get.put(LocationController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: true,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Updated HeaderBanner with reactive location/address
                HeaderBanner(
                  banners: [
                    BannerItem(image: "assets/images/banner.png", vectorImage: "assets/images/photographer.png", title: "Photography", subtitle: "Capture your moments perfectly."),
                    // BannerItem(image: "assets/images/banner.png", vectorImage: "assets/images/photographer.png", title: "Wedding", subtitle: "Plan your perfect wedding today."),
                  ],
                  height: 370,
                  color: Colors.white,
                  overlayOpacity: 0.2,
                ),

                const SizedBox(height: 24),

                // Upcoming offers
                UpcomingOfferCard(),
                const SizedBox(height: 24),

                // Categories
                CategoryScroller(
                  title: "Categories",
                  onSeeAll: () {
                    Get.to(() => CategoryListScreen());
                  },
                  categories: [
                    CategoryItem(label: "Venue", icon: Icons.place, onTap: () {}),
                    CategoryItem(label: "Photographer", icon: Icons.linked_camera_outlined, onTap: () {}),
                    CategoryItem(label: "Event", icon: Icons.event, onTap: () {}),
                    CategoryItem(label: "Makeup", icon: Icons.brush_sharp, onTap: () {}),
                    CategoryItem(label: "Catering", icon: Icons.local_dining, onTap: () {}),
                  ],
                ),

                const SizedBox(height: 24),

                // Page nav (could be Explore, Book Now, etc.)
                PageNav(),
                const SizedBox(height: 24),

                // Recommended Vendors
                RecommendedList(context: context),
                const SizedBox(height: 24),

                // Explore Section
                ExploreUs(),
                const SizedBox(height: 26),

                // Promo Slider
                PromoSlider(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
