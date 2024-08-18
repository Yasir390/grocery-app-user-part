import 'package:flutter/material.dart';

class DividerSignInScreen extends StatelessWidget {
  const DividerSignInScreen({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Flexible(
          child: Divider(
            thickness: 2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('OR',style: textTheme.titleMedium!.copyWith(
              color: Colors.white
          ),),
        ),
        const Flexible(
          child: Divider(
            thickness: 2,
          ),
        )
      ],
    );
  }
}
