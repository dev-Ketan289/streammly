import 'package:flutter/material.dart';

class HeaderBanner extends StatelessWidget {
  final double height;
  final String location;
  final String address;
  final String title;
  final String subtitle;
  final String backgroundImage;
  final bool showSearchBar;
  final Color color;

  const HeaderBanner({
    super.key,
    this.location = "Mahim",
    this.address = "MTNL Telephone Colony, VSNL Colony",
    this.title = "Photography",
    this.subtitle =
        "Passionate and creative photographer with a keen eye\n"
            "for detail and a love for storytelling through images.",
    this.backgroundImage = "assets/images/banner.png",
    this.showSearchBar = true,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover)),
      child: Stack(
        children: [
          // Semi-transparent overlay
          Container(color: color),

          // Centering and constraining content width
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location row
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(location, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(address, style: const TextStyle(color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Menu, Search, Diamond
                    Row(
                      children: [
                        const Icon(Icons.menu, color: Colors.white),
                        const SizedBox(width: 8),
                        if (showSearchBar)
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: "What are you looking for",
                                  prefixIcon: Icon(Icons.search),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                              ),
                            ),
                          ),
                        if (showSearchBar) const SizedBox(width: 8),
                        const CircleAvatar(radius: 16, backgroundColor: Colors.white, child: Icon(Icons.diamond_outlined, color: Colors.amber)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(title, style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
