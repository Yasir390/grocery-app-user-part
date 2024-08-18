import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../const/const.dart';
import '../models/products_model.dart';
import '../provider/products_provider.dart';
import '../widgets/feed_items_widget.dart';
import '../widgets/on_sale_widget.dart';
import 'feeds_screen.dart';
import 'on_sale_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final productProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProvider.getProducts;
    List<ProductModel> productOnSaleProvider = productProvider.getOnSaleProducts;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.3,
              child: Swiper(
                itemCount: Consts.landingPage.length,
                autoplay: true,
                duration: 800,
                autoplayDelay: 4000,
                scrollDirection: Axis.horizontal,
                layout: SwiperLayout.DEFAULT,
                //  itemWidth: width * 0.8,
                pagination:  SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                      color: Colors.black,
                      activeColor: Colors.red.shade500),
                ),
                itemBuilder: (context, index) {
                  return Image.asset(
                    Consts.landingPage[index],
                    fit: BoxFit.fill,
                  );
                },
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, OnSaleScreen.routeName);
              },
              child: Text(
                'View all',
                style: textTheme.titleMedium,
              ),
            ),
            Row(
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  child: Row(
                    children: [
                      Text(
                        'on sale'.toUpperCase(),
                        style: textTheme.titleLarge!
                            .copyWith(color: Colors.orange.shade700),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.discount,
                        color: Colors.orange.shade900,
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    height: height * 0.3,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productOnSaleProvider.length<10
                          ?productOnSaleProvider.length
                          :10,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: productOnSaleProvider[index],
                        child: const OnSaleWidget());
                      },
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Our Products',
                    style: textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, FeedsScreen.routeName);

                    },
                    child: Text('Browse all',
                    style: textTheme.titleMedium!.copyWith(
                      color: Colors.blue
                    ),
                    ),
                  )
                ],
              ),
            ),

            GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,

                // jodi singleChildScrollView or Listview er modde GridView use korte hoi
                // tahole physics r shrinkWrap ey properties use korte hbe r tkn Gridview k
                // Expanded or Flexible diye wrap kora jabe na
                crossAxisCount: 2,
                //crossAxisSpacing: 10,
                padding: EdgeInsets.zero,
                childAspectRatio: width / (height * 0.8),
                children: List.generate(allProducts.length, (index) {
                  return  ChangeNotifierProvider.value(
                    value: allProducts[index],
                    child: const FeedsWidget(),
                  );
                })),
            // SizedBox(
            //   width: 300,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: GridView.count(
            //       crossAxisCount: 2,
            //       childAspectRatio: 240 / 250,
            //       crossAxisSpacing: 10,
            //       mainAxisSpacing: 10,
            //       children: [
            //         FeedsWidget()
            //       ]
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
