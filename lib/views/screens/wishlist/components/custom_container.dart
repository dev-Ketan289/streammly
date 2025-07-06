import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String text;

  const CustomContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        margin: EdgeInsets.only(right: 5, left: 5),
        height: 23,
        width: 91,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Color(0xFFF5EEEE)),
        ),
        child: Center(
          child: Text(text, style: Theme.of(context).textTheme.bodySmall),
        ),
      ),
    );
  }
}
