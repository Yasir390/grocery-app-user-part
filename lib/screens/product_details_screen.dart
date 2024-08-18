import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../const/firebase_const.dart';
import '../provider/cart_provider.dart';
import '../provider/products_provider.dart';
import '../provider/viewed_recently_provider.dart';
import '../provider/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../widgets/buttons/heart_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});
  static const String routeName = '/productDetailsScreen';

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  final _quantityController = TextEditingController();
  @override
  void initState() {
    _quantityController.text = '1';
    super.initState();
  }
  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentProduct = productProvider.findProdById(productId);

    bool? _isInCart = cartProvider.getCartItems.containsKey(getCurrentProduct.id);


    double usedPrice = getCurrentProduct.isOnSale?
        getCurrentProduct.salePrice:
        getCurrentProduct.price;
    double totalPrice = usedPrice * int.parse(_quantityController.text);

    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist = wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    final viewedProdProvider = Provider.of<ViewedRecentlyProvider>(context);

    return PopScope(
      onPopInvoked: (didPop)async {
        viewedProdProvider.addProductToHistory(productId: productId);
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FancyShimmerImage(
              //  imageUrl: 'https://i0.wp.com/www.khan.com.bd/wp-content/uploads/2021/01/Orange-1kg.jpg?fit=1200%2C1200&ssl=1',
              imageUrl: getCurrentProduct.imageUrl,
                height: height*0.4,
                width: width*0.8,
                boxFit: BoxFit.fill,
              ),
              Material(
                color: Theme.of(context).cardColor.withOpacity(0.2),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 6),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getCurrentProduct.title,style: textTheme.titleLarge,),
                              HeartBTN(
                                productId: getCurrentProduct.id,
                                isInWishlist: _isInWishlist,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height*0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              RichText(text:  TextSpan(
                                  text: '\$${usedPrice.toStringAsFixed(2)}',
                                  style:textTheme.titleLarge!.copyWith(
                                      color: Colors.green
                                  ),
                                  children: [
                                    TextSpan(text:getCurrentProduct.isPiece?'Piece': 'kg',
                                      style:textTheme.titleSmall!.copyWith(
                                        color: Colors.black
                                    ), )
                                  ]
                              ),

                              ),
                              Visibility(
                                  visible: getCurrentProduct.isOnSale?true:false,
                                  child: Text('\$${getCurrentProduct.price.toStringAsFixed(2)}')),
                              Container(
                                height: kTextTabBarHeight,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text('Free delivery',
                                      style: textTheme.titleLarge!.copyWith(
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    ),SizedBox(
                      height: height*0.012,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        QuantityBtn(
                          onTap: () {
                            if( _quantityController.text == '1'){
                              return;
                            }
                            else{
                              _quantityController.text = (int.parse(_quantityController.text)-1).toString();

                            }
                            setState(() {

                            });
                          },
                          boxColor: Colors.red,
                          iconName: Icons.remove_circle_outline,
                        ),
                        SizedBox(
                          width: 70,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _quantityController,
                            onChanged: (value) {
                              setState(() {

                              });
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                            ],
                            cursorColor: Colors.grey,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              ),
                            ),
                          ),
                        ),
                        QuantityBtn(
                          onTap: () {
                            _quantityController.text = (int.parse(_quantityController.text)+1).toString();
                            setState(() {

                            });
                          },
                          boxColor: Colors.green,
                          iconName: Icons.add_circle_outline,
                        )
                      ],
                    ),

                    SizedBox(
                      height: height*0.16,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total',style: textTheme.titleLarge!.copyWith(
                                  color: Colors.orange.withOpacity(0.8),
                                  fontWeight: FontWeight.bold
                              ),),
                              Row(
                                children: [
                                  Text('\$${totalPrice.toStringAsFixed(2)}',
                                    style: textTheme.titleLarge,
                                  ),
                                  Text('/${getCurrentProduct.isPiece ? 'Piece':'Kg'}',
                                    style: textTheme.titleLarge,
                                  )
                                  // Text('${_quantityController.text}/${getCurrentProduct.isPiece ? 'Piece':'Kg'}',
                                  //   style: textTheme.titleLarge,
                                  // )
                                ],
                              )

                            ],
                          ),
                          InkWell(
                            onTap: () async {
                              final User? user = authInstance.currentUser;
                              if(user == null){
                                return;
                              }

                              _isInCart?
                              null:
                              await GlobalMethods.addToCart(context,
                                  productId:getCurrentProduct.id ,
                                  quantity: int.parse(_quantityController.text)
                              );
                              await cartProvider.fetchCart();
                              // cartProvider.addProductsToCart(
                              //   productId: getCurrentProduct.id,
                              //   quantity: int.parse(_quantityController.text),
                              // );
                              setState(() {

                              });
                            },
                            child: Container(
                              height: kTextTabBarHeight,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(_isInCart?'In Cart':'Add to cart',
                                    style: textTheme.titleLarge!.copyWith(
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class QuantityBtn extends StatelessWidget {
   const QuantityBtn({
    super.key,required this.onTap,required this.boxColor,required this.iconName,
  });
  final IconData iconName;
   final Color boxColor;
   final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(iconName,color: Colors.white,),
      ),
    );
  }
}
