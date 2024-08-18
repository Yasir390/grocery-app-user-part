import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/models/wishlist_model.dart';
import 'package:grocery_app/provider/products_provider.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../../const/firebase_const.dart';
import '../../const/flutter_toast.dart';
import '../../provider/wishlist_provider.dart';


class HeartBTN extends StatelessWidget {
  const HeartBTN({
    super.key,
    required this.productId,
     this.isInWishlist = false,
  });

  final String productId;
  final bool isInWishlist;

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProdById(productId);
   // final wishlistModel = Provider.of<WishListModel>(context);
   // bool? isInWishList =   wishlistProvider.getWishlistItems.containsKey(productId);
    return GestureDetector(
        onTap: () async {
          final User? user = authInstance.currentUser;

          if(user == null ){
            toastMsg(msg: 'No user found! Please Login');
            return;
          }
          isInWishlist?
        await  wishlistProvider.removeFromWishlist(
            wishId: wishlistProvider.getWishlistItems[getCurrProduct.id]!.id,
            productId: productId)
              :
          await  GlobalMethods.addToWishlist(context, productId: productId);

          await wishlistProvider.fetchWishlist();

          },
        child: Icon(isInWishlist != null && isInWishlist == true? Icons.favorite:Icons.favorite_outline,
        color: isInWishlist != null && isInWishlist == true? Colors.red:Colors.black,
        ));
  }
}