import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocery_app/const/const.dart';
import 'package:grocery_app/const/firebase_const.dart';
import 'package:grocery_app/provider/cart_provider.dart';
import 'package:grocery_app/provider/orders_provider.dart';
import 'package:grocery_app/provider/wishlist_provider.dart';
import 'package:grocery_app/screens/bottom_nav_screen.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({super.key});

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {

  List images = Consts.landingPage;
  @override
  void initState() {
    images.shuffle();
    final productsProvider = Provider.of<ProductsProvider>(context,listen: false);
    final cartProvider = Provider.of<CartProvider>(context,listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context,listen: false);
    final orderProvider = Provider.of<OrderProvider>(context,listen: false);
     User? user = authInstance.currentUser;

    if(user == null){
      productsProvider.fetchProducts();
      cartProvider.clearLocalCart();
      wishlistProvider.clearLocalWishlist();
      orderProvider.clearLocalOrders();
     }
    else{
      productsProvider.fetchProducts();
      cartProvider.fetchCart();
      wishlistProvider.fetchWishlist();
    }

    Timer(const Duration(seconds: 2), () {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavScreen(),));
    });

    // Future.delayed(const Duration(microseconds: 50),()async {},);//also we can use it as alternative//
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final productsProvider = Provider.of<ProductsProvider>(context,listen: false);
    // productsProvider.fetchProducts();
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(images[1],
            fit: BoxFit.cover,height: double.infinity,),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          const Center(child: SpinKitFadingCube(

            color: Colors.white,
          ))
        ],
      ),
    );
  }
}