import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/profile/components/custom_button.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start a new chat',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: backgroundDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'With',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: backgroundDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SvgPicture.asset(
                    Assets.svgBot,
                    width: 25,
                    height: 30,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Chat Bot AI',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      CustomButton(
                        height: 35,
                        width: 35,
                        iconData: Icons.phone,
                        iconColor: Colors.white,
                        borderColor: Color(0xffC5DCF5),
                        borderWidth: 2,
                        onTap: () {},
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CustomButton(
                        height: 35,
                        width: 35,
                        svgPath: Assets.svgCall,
                        borderColor: Color(0xffC5DCF5),
                        borderWidth: 2,
                        iconSize: 17,
                        onTap: () {},
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                color: Color(0xff776F69).withAlpha(50),
                thickness: 1,
              ),
              Center(
                child: Text(
                  'How can I help you my friend? 😊️',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: backgroundDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Chat messages list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    // Bot message
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bot avatar
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey[300],
                            child: Icon(Icons.android, color: Colors.grey[700], size: 20),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: Color(0xff3B7ED0),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  topRight: Radius.circular(14),
                                  bottomRight: Radius.circular(14),
                                ),
                              ),
                              child: Text(
                                "Good morning, anything we can help at Company Name?",
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 48, top: 2, bottom: 12),
                      child: Text(
                        "11:20 PM",
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ),
                    // User message 1
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: Color(0xffE6F3FB),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              "Hello, good morning ;)",
                              style: TextStyle(color: Colors.black87, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 4, bottom: 12),
                            child: Text(
                              "11:20 PM",
                              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // User message 2
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: Color(0xffE6F3FB),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              "This look awesome 😍",
                              style: TextStyle(color: Colors.black87, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // User image message
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Color(0xffE6F3FB),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&w=120&h=120&fit=crop',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // User message 3
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: Color(0xffE6F3FB),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              "I would like to book an appointment at 2:30 PM today.",
                              style: TextStyle(color: Colors.black87, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 4, bottom: 12),
                            child: Text(
                              "11:20 PM",
                              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Ask me anything...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F6FA),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.image_outlined, color: Colors.grey[700]),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xff3B7ED0),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
