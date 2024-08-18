import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  const QuantityButton({
    super.key,
    required this.onTap,
    required this.iconName,
    required this.boxColor,
  });

  final IconData iconName;
  final Color boxColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: boxColor,
          ),
          child: Icon(iconName, color: Colors.white),
        ),
      ),
    );
  }
}