import 'package:flutter/material.dart';

class Consts{
  static   List offerImage = [
    'assets/offerImage/offer1.jpg',
    'assets/offerImage/offer2.jpg',
    'assets/offerImage/offer3.jpg',
    'assets/offerImage/offer4.jpg',
  ];

  static   List landingPage = [
    'assets/landing_page/buy-on-laptop.jpg',
    'assets/landing_page/buy-through.png',
    'assets/landing_page/buyfood.jpg',
    'assets/landing_page/grocery-cart.jpg',
    'assets/landing_page/vegetable.jpg'
  ];
  static InputDecoration inputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white),
      border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
    );
  }

}
