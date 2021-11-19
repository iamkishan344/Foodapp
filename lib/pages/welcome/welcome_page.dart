import 'package:flutter/material.dart';
import 'package:foodapp/pages/welcome/components/center_part.dart';
import 'package:foodapp/pages/welcome/components/end_part.dart';
import 'package:foodapp/pages/welcome/components/top_part.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Top Part
              TopPart(),

              // Center Part
              CenterPart(),

              // End Part
              EndPart(),
            ],
          ),
        ),
      ),
    );
  }
}
