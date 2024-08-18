import 'package:flutter/material.dart';

class EmptyScreen extends StatefulWidget {
  const EmptyScreen({super.key});

  @override
  State<EmptyScreen> createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
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
            'Your Cart is empty! ',
            style: textTheme.titleLarge!.copyWith(),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Add something and make me happy! ',
            style: textTheme.titleLarge!.copyWith(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {

            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(
                  color: Colors.black,
                  width: 2
                )
              )
            ),
            child: Text('Shop Now',style: textTheme.titleMedium,),
          ),
        ],
      ),
    );
  }
}
