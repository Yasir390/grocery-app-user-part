import 'package:flutter/material.dart';

class EmptyProductWidget extends StatefulWidget {
  const EmptyProductWidget({super.key, this.text='Your Cart is empty! '});

  final String text;
  @override
  State<EmptyProductWidget> createState() => _EmptyProductWidgetState();
}

class _EmptyProductWidgetState extends State<EmptyProductWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: const AssetImage(
              'assets/images/empty.jpg',
            ),
            height: height*0.45,
            width: width*0.8,
            fit: BoxFit.cover,
          ),
          Text(
            'Whoops! ',
            style: textTheme.headlineLarge!.copyWith(color: Colors.red,fontWeight: FontWeight.w900),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.text,
            style: textTheme.titleLarge!.copyWith(),
          ),
          const SizedBox(
            height: 20,
          ),
]
    )
      );
  }
}
