import 'package:flutter/material.dart';

import '../../screens/auth/forget_pass_screen.dart';

class ForgetPasswordBtn extends StatelessWidget {
  const ForgetPasswordBtn({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, ForgetPassScreen.routeName);
      },
      child:  Text('Forget Password?',
        style: textTheme.titleMedium!.copyWith(
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
            color: Colors.blue,
            decorationColor: Colors.blue,
            decorationThickness: 2
        ),
      ),
    );
  }
}
