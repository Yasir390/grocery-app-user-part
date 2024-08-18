import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/widgets/quantity_button.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../provider/cart_provider.dart';
import '../provider/products_provider.dart';
import '../provider/wishlist_provider.dart';
import '../screens/product_details_screen.dart';
import 'buttons/heart_button.dart';



class CartWidget extends StatefulWidget {
  const CartWidget({super.key, required this.q});

  final int q;
  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();
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


    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrentProduct = productProvider.findProdById(cartModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    double usedPrice = getCurrentProduct.isOnSale? getCurrentProduct.salePrice: getCurrentProduct.price;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist = wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetailsScreen.routeName,arguments: cartModel.productId);
        },
        child: Material(
          color: Colors.blue.shade200,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Expanded(
                child: Row(
                  children: [
                    Container(
                      height: width * 0.25,
                      width: width * 0.25,
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12)),
                      child: FancyShimmerImage(
                        imageUrl:getCurrentProduct.imageUrl,
                        height: height * 0.15,
                        width: width * 0.26,
                        boxFit: BoxFit.fill,
                      ),
                    ),

                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getCurrentProduct.title,
                              style: textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Row(
                            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                QuantityButton(
                                  onTap: () {
                                    if (_quantityTextController.text == '1') {
                                      return;
                                    } else {
                                      cartProvider.reduceQuantityByOne(cartModel.productId);
                                      _quantityTextController.text =
                                          (int.parse(_quantityTextController.text) -
                                              1)
                                              .toString();
                                    }
                                    setState(() {});
                                  },
                                  iconName: Icons.remove,
                                  boxColor: Colors.red,
                                ),
                                SizedBox(
                                  width: width * 0.08,
                                  child: TextField(
                                    controller: _quantityTextController,
                                    keyboardType: TextInputType.number,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    onChanged: (value) {
                                      value.isEmpty
                                          ? _quantityTextController.text = '1'
                                          : null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9]'))
                                    ],
                                  ),
                                ),
                                QuantityButton(
                                  onTap: () {
                                    cartProvider.increaseQuantityByOne(cartModel.productId);
                                    _quantityTextController.text =
                                        (int.parse(_quantityTextController.text) +
                                            1)
                                            .toString();
                                    setState(() {
                                    });
                                  },
                                  iconName: Icons.add,
                                  boxColor: Colors.green,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),

              //Remove one item from cart
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                     InkWell(
                    onTap: () {
                      cartProvider.removeOneItem(productId: cartModel.productId, quantity: cartModel.quantity, cartId: cartModel.id);
                    },
                        child: const Icon(Icons.remove_shopping_cart_outlined)),
                    HeartBTN(
                      productId: getCurrentProduct.id,
                      isInWishlist: _isInWishlist,
                    ),
                    Text(
                      '\$${(usedPrice * int.parse(_quantityTextController.text)).toStringAsFixed(1)}',
                      style: textTheme.titleMedium,
                    )
                  ],
                ),
              )
            ],    //   Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.pushNamed(context, ProductDetailsScreen.routeName);
            //     },
            //     child: Row(
            //       //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         Container(
            //           decoration: BoxDecoration(
            //               color: Theme.of(context).cardColor.withOpacity(0.3),
            //               borderRadius: BorderRadius.circular(12)),
            //           child: Row(
            //          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Container(
            //                 height: width * 0.25,
            //                 width: width * 0.25,
            //                 decoration:
            //                     BoxDecoration(borderRadius: BorderRadius.circular(12)),
            //                 child: FancyShimmerImage(
            //                   imageUrl:getCurrentProduct.imageUrl,
            //                   height: height * 0.15,
            //                   width: width * 0.26,
            //                   boxFit: BoxFit.fill,
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       getCurrentProduct.title,
            //                       style: textTheme.titleMedium,
            //                     ),
            //                     Row(
            //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         QuantityButton(
            //                           onTap: () {
            //                             if (_quantityTextController.text == '1') {
            //                               return;
            //                             } else {
            //                               _quantityTextController.text =
            //                                   (int.parse(_quantityTextController.text) -
            //                                           1)
            //                                       .toString();
            //                             }
            //                             setState(() {});
            //                           },
            //                           iconName: Icons.remove,
            //                           boxColor: Colors.red,
            //                         ),
            //                         SizedBox(
            //                           width: width * 0.08,
            //                           child: TextField(
            //                             controller: _quantityTextController,
            //                             keyboardType: TextInputType.number,
            //                             maxLines: 1,
            //                             textAlign: TextAlign.center,
            //                             onChanged: (value) {
            //                               value.isEmpty
            //                                   ? _quantityTextController.text = '1'
            //                                   : null;
            //                             },
            //                             inputFormatters: [
            //                               FilteringTextInputFormatter.allow(
            //                                   RegExp('[0-9]'))
            //                             ],
            //                           ),
            //                         ),
            //                         QuantityButton(
            //                           onTap: () {
            //                             _quantityTextController.text =
            //                                 (int.parse(_quantityTextController.text) +
            //                                         1)
            //                                     .toString();
            //                           },
            //                           iconName: Icons.add,
            //                           boxColor: Colors.green,
            //                         ),
            //                       ],
            //                     )
            //                   ],
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: width * 0.14,
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.all(0.0),
            //                 child: Column(
            //                   children: [
            //                     const InkWell(
            //                         child: Icon(Icons.shopping_cart_outlined)),
            //                     const InkWell(child: Icon(Icons.favorite_outline)),
            //                     Text(
            //                       '\$${usedPrice.toStringAsFixed(2)}',
            //                       style: textTheme.titleMedium,
            //                     )
            //                   ],
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // );
          ),
        ),
      ),
    );


  }
}


