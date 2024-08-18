import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products_model.dart';
import '../provider/products_provider.dart';
import '../widgets/on_sale_widget.dart';


class OnSaleScreen extends StatelessWidget {
  static const String routeName = '/onSaleScreen';
  const OnSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;


    final productProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> productsOnSale = productProvider.getOnSaleProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products on sale'),
      ),
      body:productsOnSale.isEmpty? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/empty.jpg',
              ),
            ),
             Text('No items to on sale\n stay tuned ',
               style: textTheme.headlineLarge,
               textAlign: TextAlign.center,
               ),
          ],
        ),
      ): GridView.count(
          // physics: const NeverScrollableScrollPhysics(),
          // shrinkWrap: true,

          // jodi singleChildScrollView or Listview er modde GridView use korte hoi
          // tahole physics r shrinkWrap ey properties use korte hbe r tkn Gridview k
          // Expanded or Flexible diye wrap kora jabe na
          crossAxisCount: 2,
          //crossAxisSpacing: 10,
          padding: EdgeInsets.zero,
          childAspectRatio: width / (height * 0.6),
          children: List.generate(productsOnSale.length, (index) {
            return  ChangeNotifierProvider.value(
                value: productsOnSale[index],
               child: const OnSaleWidget());
          })),
    );
  }
}
