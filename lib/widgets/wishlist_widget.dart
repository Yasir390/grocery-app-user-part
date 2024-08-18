import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/wishlist_model.dart';
import '../provider/products_provider.dart';
import '../provider/wishlist_provider.dart';
import '../screens/product_details_screen.dart';
import 'buttons/heart_button.dart';

class WishListWidget extends StatefulWidget {
  const WishListWidget({super.key});

  @override
  State<WishListWidget> createState() => _WishListWidgetState();
}

class _WishListWidgetState extends State<WishListWidget> {

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;


    // Get the screen size in pixels
    final Size screenSize = MediaQuery.of(context).size;

    // Get the device pixel ratio
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    // Calculate device width and height in pixels
    final double deviceWidth = screenSize.width * pixelRatio;
    final double deviceHeight = screenSize.height * pixelRatio;

   // print('Device Width: ${deviceWidth.toStringAsFixed(2)} pixels');
   // print('1 pixel Width: ${(100/deviceWidth).toStringAsFixed(2)} pixels');
   // print('Device Height: ${deviceHeight.toStringAsFixed(2)} pixels');
   // print('1 pixel Height: ${(100/deviceHeight).toStringAsFixed(2)} pixels');
   final productProvider = Provider.of<ProductsProvider>(context);
    final wishlistModel = Provider.of<WishListModel>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final getCurrentProduct = productProvider.findProdById(wishlistModel.productId);
   final usedPrice = getCurrentProduct.isOnSale? getCurrentProduct.salePrice:getCurrentProduct.price;
   bool? _isInWishlist = wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetailsScreen.routeName,arguments: getCurrentProduct.id);
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          height: height*.2, //1px = 0.07
          width: width*0.45, //1px = 0.14
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blue.withOpacity(0.2),
            border: Border.all(color: Colors.blue,width: 2)
          ),
          child: Flexible(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FancyShimmerImage(
                 // imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXgZDmjRAXgyEi2xTlUkK-rpxtZ8as87cjJw&s',
                  imageUrl: getCurrentProduct.imageUrl,
                  height: height*0.1,
                  width: width*0.22,
                  boxFit: BoxFit.fill,
                ),
                Flexible(
                  flex: 3,
                  child: Column(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       Row(
                        children: [
                          const Icon(Icons.shopping_bag_outlined),
                          const SizedBox(width: 8,),
                          HeartBTN(
                            productId:getCurrentProduct .id,
                            isInWishlist: _isInWishlist,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Text(
                        getCurrentProduct.title,
                        style: textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('\$${usedPrice.toStringAsFixed(2)}',style: textTheme.titleMedium,)

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
