import 'package:flutter/material.dart';
import 'package:streammly/services/theme.dart';

class CustomSettingsContainer extends StatelessWidget {
  const CustomSettingsContainer({super.key, required this.title, required this.description, });
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        height: 65,
        width: double.infinity,
        decoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: title, style: TextStyle(color: backgroundDark, fontSize: 16, fontWeight: FontWeight.bold),),
                      TextSpan(text: description, style: TextStyle(color: backgroundDark, fontSize: 11, ),),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.arrow_forward_ios, color: backgroundDark, size: 15,),
            ],
          ),
        ),
      ),
    );
  }
}