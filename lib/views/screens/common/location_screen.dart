import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/location_controller.dart';
import 'package:streammly/views/screens/common/enter_location_manually.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Location", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Let us know the spot.....\nwe’ll bring the magic there.", textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.black54)),
              ),
              const SizedBox(height: 20),
              Image.asset('assets/images/location_girl_map.png', height: 220),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          await Get.find<LocationController>().getCurrentLocation();
                          Get.to(() => EnterLocationManuallyScreen());
                        },
                        child: const Text("Use Current Location", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.blue), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          Get.to(() => EnterLocationManuallyScreen());
                        },
                        child: const Text("Enter Location Manually", style: TextStyle(color: Colors.blue, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Image.asset('assets/images/location_map_bottom.jpg', fit: BoxFit.cover, width: double.infinity, height: 180),
            ],
          ),
        ),
      ),
    );
  }
}
