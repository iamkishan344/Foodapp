import 'package:flutter/material.dart';
import 'package:foodapp/pages/login/login_page.dart';
import 'package:foodapp/pages/signup/signup_page.dart';
import 'package:foodapp/route/routing_page.dart';
import 'package:foodapp/widgets/my_button.dart';

class EndPart extends StatelessWidget {
  const EndPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyButton(
          onPressed: () {
            RoutingPage.goTonext(
              context: context,
              navigateTo: LoginPage(),
            );
          },
          text: "Login",
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
            onTap: () {
              RoutingPage.goTonext(
                context: context,
                navigateTo: SignupPage(),
              );
            },
            child: Text("SIGNUP", style: TextStyle(color: Color(0xff797b7a)))),
      ],
    );
  }
}
