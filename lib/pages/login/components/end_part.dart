import 'package:flutter/material.dart';
import 'package:foodapp/pages/signup/signup_page.dart';
import 'package:foodapp/route/routing_page.dart';
import 'package:foodapp/widgets/my_button.dart';

class EndPart extends StatelessWidget {
  final void Function()? onPressed;
  final bool loading;
  const EndPart({
    required this.loading,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        loading == true
            ? CircularProgressIndicator()
            : MyButton(
                onPressed: onPressed,
                text: "Log In",
              ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account?\t\t"),
            GestureDetector(
                onTap: () {
                  RoutingPage.goTonext(
                    context: context,
                    navigateTo: SignupPage(),
                  );
                },
                child: Text("SIGN UP")),
          ],
        )
      ],
    );
  }
}
