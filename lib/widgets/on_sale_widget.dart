import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/widgets/price_widget.dart';
import 'package:provider/provider.dart';
import '../const/firebase_const.dart';
import '../const/flutter_toast.dart';
import '../models/products_model.dart';
import '../provider/cart_provider.dart';
import '../provider/wishlist_provider.dart';
import '../screens/product_details_screen.dart';
import 'buttons/heart_button.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({super.key});

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;

    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist = wishlistProvider.getWishlistItems.containsKey(productModel.id);


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.2),
        child: InkWell(
          //borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushNamed(context, ProductDetailsScreen.routeName,arguments: productModel.id);

          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FancyShimmerImage(
                      imageUrl: productModel.imageUrl,
                      height: height*0.15,
                      width: width*0.26,
                      boxFit: BoxFit.fill,
                    ),

                    Column(
                      children: [
                        Text(productModel.isPiece?'Piece':'KG',
                        style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: height*0.006,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final User? user = authInstance.currentUser;
                                if(user == null){
                                  toastMsg(msg: 'No user found! Please Login');
                                  return;
                                }
                                if(_isInCart){
                                  return;
                                }else{
                                  setState(() async {
                                    await GlobalMethods.addToCart(context,
                                        productId:productModel.id ,
                                        quantity: 1
                                    );
                                    await cartProvider.fetchCart();
                                  });
                                }
                              },
                                child: Icon(_isInCart?Icons.shopping_bag: Icons.shopping_bag_outlined,
                                color: _isInCart?Colors.green:Colors.black,)),
                            HeartBTN(
                              productId: productModel.id,
                              isInWishlist: _isInWishlist,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
                 PriceWidget(
                  isOnSale: true,
                  salePrice: productModel.salePrice,
                  price: productModel.price,
                  textPrice: '1',
                ),
               // SizedBox(height: height*0.002,),
                 Text(productModel.title,
                style:textTheme.titleMedium ,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
