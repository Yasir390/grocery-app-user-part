import 'package:flutter/material.dart';

class ReusableElevatedBtn extends StatelessWidget {
  const ReusableElevatedBtn({
    super.key, required this.buttonTitle, required this.onPressed,
  });
  final String buttonTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: kBottomNavigationBarHeight,
      child: ElevatedButton(
        onPressed:onPressed,
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            )
        ),
        child:  Text(buttonTitle,
        ),
      ),
    );
  }
}