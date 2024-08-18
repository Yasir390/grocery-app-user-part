import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/widgets/price_widget.dart';
import 'package:provider/provider.dart';
import '../const/firebase_const.dart';
import '../models/products_model.dart';
import '../provider/cart_provider.dart';
import '../provider/wishlist_provider.dart';
import '../screens/product_details_screen.dart';
import '../services/global_methods.dart';
import 'buttons/heart_button.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({super.key});


  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }
  @override
  void dispose() {
   _quantityTextController.dispose();
    super.dispose();
  }

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
      padding: const EdgeInsets.all(4.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.3),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, ProductDetailsScreen.routeName,arguments: productModel.id);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                FancyShimmerImage(
                 imageUrl:productModel.imageUrl,
                  height: height*0.15,
                  width: width*0.26,
                  boxFit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 5,
                ),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 8),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(productModel.title,
                        style:textTheme.titleMedium!.copyWith(
                          overflow: TextOverflow.ellipsis
                        ) ,
                           maxLines: 1,
                        ),
                      ),
                      HeartBTN(
                        productId: productModel.id,
                        isInWishlist: _isInWishlist,
                      )
                    ],
                   ),
                 ),
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: PriceWidget(
                          isOnSale:productModel.isOnSale,
                          salePrice: productModel.salePrice,
                          price: productModel.price,
                          textPrice: _quantityTextController.text,
                        ),
                      ),
                      // Flexible(
                      //   child: PriceWidget(
                      //   salePrice: salePrice,
                      //   price: price,
                      //   textPrice: textPrice,
                      //   isOnSale: isOnSale,
                      // )),
                      // Text(_quantityTextController.text.isEmpty ?'\$2.9':'\$${2.9* int.parse(_quantityTextController.text) ?? 1}',
                      // style: textTheme.titleMedium!.copyWith(
                      //   color: Colors.green
                      // ),
                      // ),
                      // PriceWidget(),
                     const SizedBox(width:10,),
                       Flexible(
                         child: Row(
                           children: [
                              FittedBox(
                                  child: Text(
                                    productModel.isPiece?'Piece':'Kg',
                             style: textTheme.titleSmall,
                             )),
                             const SizedBox(width: 3,),
                             Flexible(
                                 child: TextFormField(
                               controller: _quantityTextController ,
                               keyboardType: TextInputType.number,
                               textAlign: TextAlign.center,
                               key: const ValueKey('10'),
                              style: textTheme.titleSmall,
                              onChanged: (value) {
                                setState(() {

                                });
                              },
                              // style: TextStyle(fontSize: 18),
                               maxLines: 1,
                               enabled: true,
                               cursorColor: Colors.black,
                               inputFormatters: [
                                 FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                               ],
                             ))
                           ],
                         ),
                       )
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      final User? user = authInstance.currentUser;
                      if(user == null){
                        return;
                      }

                      _isInCart
                          ?null
                          :
                     await  GlobalMethods.addToCart(context,
                          productId:productModel.id ,
                          quantity: int.parse(_quantityTextController.text)
                      );
                      await cartProvider.fetchCart();
                      // cartProvider.addProductsToCart(
                      //   productId: productModel.id,
                      //   quantity: int.parse(_quantityTextController.text.trim()),
                      // );
                      // setState(() {
                      //
                      // });
                    },
                    child:  Text(_isInCart? 'In Cart':'Add to Cart',
                    style: textTheme.titleMedium!.copyWith(
                    //  color: Colors.green
                    ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

