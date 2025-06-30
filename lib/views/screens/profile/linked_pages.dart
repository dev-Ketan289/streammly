import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/views/screens/profile/components/profile_section_widget.dart';

class LinkedPages extends StatelessWidget {
  const LinkedPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9FD),
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: const Text(
          "Linked Accounts",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2864A6),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProfileSectionWidget(title: 'Linked Accounts'),
          SizedBox(height: 24),
          Linked(icon: SvgPicture.asset(Assets.svgGoogle), title: 'Google'),
          Linked(
            icon: SvgPicture.asset(Assets.svgInstagram),
            title: 'Instagram',
          ),
          Linked(icon: SvgPicture.asset(Assets.svgFacebook), title: 'Facebook'),
          Linked(icon: SvgPicture.asset(Assets.svgGmail), title: 'Gmail'),
        ],
      ),
    );
  }
}

class Linked extends StatefulWidget {
  const Linked({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  final Widget icon;
  final String title;
  final VoidCallback? onTap;

  @override
  State<Linked> createState() => _LinkedState();
}

class _LinkedState extends State<Linked> {
  bool isLinked = false;

  void toggleLink() {
    setState(() {
      isLinked = !isLinked;
    });

    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Colors.white,
        leading: widget.icon,
        title: Text(widget.title),
        trailing: GestureDetector(
          onTap: toggleLink,
          child: Container(
            height: 28,
            width: 63,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isLinked ? Colors.black : const Color(0xFFDFEEFF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                isLinked ? 'Unlink' : 'Link',
                style: TextStyle(
                  color: isLinked ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        onTap: widget.onTap,
      ),
    );
  }
}
