import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import '../const/const.dart';

class SwiperWidget extends StatelessWidget {
  const SwiperWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Swiper(
      autoplay: true,
      duration: 800,
      autoplayDelay: 5000,
      scrollDirection: Axis.horizontal,
      layout: SwiperLayout.DEFAULT,
      itemCount: Consts.landingPage.length,
      itemBuilder: (context, index) {
        return Image.asset(
          Consts.landingPage[index],
          fit: BoxFit.fill,
        );
      },
    );
  }
}
