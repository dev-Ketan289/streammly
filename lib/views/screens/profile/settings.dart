import 'package:flutter/material.dart';
import 'package:streammly/services/route_helper.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/profile/components/custom_settings_container.dart';
import 'package:streammly/views/screens/profile/profile_screen.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xff666666),),
          ),
          title: Text("Settings", style: TextStyle(color: primaryColor, fontSize: 20,fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            GestureDetector(onTap:(){
              Navigator.push(context, getCustomRoute(child:ProfileScreen()));
            },child: CustomSettingsContainer(title: "Edit Profile\n", description: "Change your name, descrription and profile photo",)),
            GestureDetector(onTap:(){
            },child: CustomSettingsContainer(title: "Notification Settings\n", description: "Define what alerts and notifications you want to see",)),
            GestureDetector(onTap:(){
            },child: CustomSettingsContainer(title: "Account Settings\n", description: "Delete your account",),),
          ],
        ),
      ),
    );
  }
}