import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:streammly/generated/assets.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final String dateTime;
  final String review;
  final double rating;

  const ReviewCard({
    super.key,
    required this.name,
    required this.dateTime,
    required this.review,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 200,
            height: 180,
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 20),
            margin: const EdgeInsets.only(
              top: 28,
              right: 12,
              left: 12,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xffF5EEEE), width: 2),
              // boxShadow: const [
              //   BoxShadow(
              //     color: Colors.black12,
              //     blurRadius: 8,
              //     offset: Offset(0, 4),
              //   ),
              // ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 22,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  name.endsWith('.') ? name : name + '.',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateTime,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xff918181),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  review,
                  style: const TextStyle(fontSize: 8, color: Color(0xFF757575)),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.transparent,
              child: Image.asset(Assets.imagesReview, width: 55, height: 55),
            ),
          ),
        ],
      ),
    );
  }
}
