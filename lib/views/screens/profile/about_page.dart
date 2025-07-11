import 'package:flutter/material.dart';
import 'package:streammly/services/theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          title: Text("About", style: TextStyle(color: primaryColor, fontSize: 20,fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Column(

          children: [
            GestureDetector(onTap:(){
            },child: CustomContainer(title: "Terms & Service\n", )),
            GestureDetector(onTap:(){
            },child: CustomContainer(title: "App Version\n", description: "v18.9.8 Live",)),
            GestureDetector(onTap:(){
            },child: CustomContainer(title: "Open Source Libraries\n",),),
            GestureDetector(onTap:(){
            },child: CustomContainer(title: "Licenses & Registrations\n",),),
        
          ],
        ),
      ),);

  }     
           
}



class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key, required this.title, this.description = "", });
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Container(
        height: description.isNotEmpty ? 65 : 50,
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
                      TextSpan(text: title, style: TextStyle(color: backgroundDark, fontSize: 16, ),),
                      if (description.isNotEmpty)
                        TextSpan(text: description, style: TextStyle(color: Color(0xffB7B5B5), fontSize: 15, ),),
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