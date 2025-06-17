import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/views/screens/home/widgets/category/category.dart';
import 'package:streammly/views/screens/home/widgets/category/explore_us.dart';
import 'package:streammly/views/screens/home/widgets/category/page_nav.dart';
import 'package:streammly/views/screens/home/widgets/category/recommended_list.dart';
import 'package:streammly/views/screens/home/widgets/category/widgets/category_scroller.dart';
import 'package:streammly/views/screens/home/widgets/header_banner.dart';
import 'package:streammly/views/screens/home/widgets/promo_slider.dart';

import '../../../controllers/home_screen_controller.dart';
import '../../../models/banner/banner_item.dart';
import '../../../models/category/category_item.dart';
import 'widgets/upcoming_offer_card.dart';

class HomeScreen extends StatelessWidget {
  final List<String> promoSlider = ["assets/images/category/media.png"];
  final HomeController controller = Get.put(HomeController());

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
                HeaderBanner(
                  banners: [
                    BannerItem(image: "assets/images/banner.png", vectorImage: "assets/images/photographer.png", title: "Photography", subtitle: "Capture your moments perfectly."),
                    BannerItem(image: "assets/images/banner.png", vectorImage: "assets/images/photographer.png", title: "Wedding", subtitle: "Plan your perfect wedding today."),
                    // Add more from backend
                  ],
                  height: 370,
                  location: "Mahim",
                  address: "MTNL Telephone Colony, VSNL Colony",
                  color: Colors.white.withValues(alpha: 0.4),
                  overlayOpacity: 0.2,
                ),
                const SizedBox(height: 24),
                UpcomingOfferCard(),
                const SizedBox(height: 24),
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
                PageNav(),
                const SizedBox(height: 24),
                RecommendedList(context: context),
                const SizedBox(height: 24),
                ExploreUs(context: context),
                SizedBox(height: 26),
                PromoSlider(),

                // You can add more widgets below for category, offers, explore etc.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
