import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/widgets/quantity_button.dart';
import 'package:provider/provider.dart';

import '../const/firebase_const.dart';
import '../const/flutter_toast.dart';
import '../models/viewed_model.dart';
import '../provider/cart_provider.dart';
import '../provider/products_provider.dart';
import '../services/global_methods.dart';

class ViewedWidget extends StatefulWidget {
  const ViewedWidget({super.key});

  @override
  State<ViewedWidget> createState() => _ViewedWidgetState();
}

class _ViewedWidgetState extends State<ViewedWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    final productProvider = Provider.of<ProductsProvider>(context);
    final viewedProdModel = Provider.of<ViewedRecentlyModel>(context);
    final getCurrentProduct = productProvider.findProdById(viewedProdModel.productId);
    double usedPrice = getCurrentProduct.isOnSale?getCurrentProduct.salePrice:getCurrentProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    return Card(
      child: ListTile(
        onTap: () {
       //   Navigator.pushNamed(context, ProductDetailsScreen.routeName);
        },
        leading: FancyShimmerImage(
          imageUrl:getCurrentProduct.imageUrl,
          height: height * 0.1,
          width: width * 0.2,
          boxFit: BoxFit.fill,
        ),
        title: Text(
          getCurrentProduct.title,
          style: textTheme.titleLarge,
        ),
        subtitle: Text(
          '\$${usedPrice.toStringAsFixed(2)}',
          style: textTheme.titleSmall,
        ),
        trailing: QuantityButton(
          onTap:() async {
            final User? user = authInstance.currentUser;
            if(user == null){
              toastMsg(msg: 'Please login');
              return;
            }

            _isInCart
                ?null:
           await GlobalMethods.addToCart(context,
                productId:getCurrentProduct.id ,
                quantity: 1
            );
            await cartProvider.fetchCart();
            // cartProvider.addProductsToCart(
            //   productId: getCurrentProduct.id,
            //   quantity: 1,
            // );
            setState(() {

            });
          },
          iconName:_isInCart? Icons.check:Icons.add,
            boxColor: Colors.green,
          ),
      ),
    );
  }
}