import 'package:flutter/material.dart';

class ProfileFormScreen extends StatelessWidget {
  const ProfileFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Profile")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("New User Detected", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Here you can build your profile form."),
          ],
        ),
      ),
    );
  }
}
