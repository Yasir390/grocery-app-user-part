import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/const/firebase_const.dart';
import 'package:grocery_app/const/flutter_toast.dart';
import 'package:grocery_app/provider/orders_provider.dart';
import 'package:grocery_app/provider/products_provider.dart';
import 'package:grocery_app/screens/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../provider/cart_provider.dart';
import '../services/global_methods.dart';
import '../widgets/cart_widget.dart';
import 'empty_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final ordersProvider = Provider.of<OrderProvider>(context);

    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale? getCurrProduct.salePrice:getCurrProduct.price) * value.quantity;
    });
  bool isLoading = false;
    return cartItemsList.isEmpty
        ? const EmptyScreen()
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Cart(${cartItemsList.length})',
                  style: textTheme.titleLarge,
                ),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: () {
                      GlobalMethods.showLogoutDialog(
                        context: context,
                        title: 'Delete Cart',
                        content: 'Are you sure?',
                        actionText: 'Yes',
                        onPressed: () async {
                         await cartProvider.clearOnlineCart();
                          Navigator.pop(context);
                        },
                      );
                    },
                    icon: const Icon(Icons.delete_outline),
                  )
                ],
              ),
              body: LoadingManager(
                isLoading: isLoading,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async{
                              setState(() {
                                isLoading = true;
                              });
                              User? user = authInstance.currentUser;

                              final productProvider = Provider.of<ProductsProvider>(context,listen: false);
                              cartProvider.getCartItems.forEach((key, value) async {
                                final getCurrProduct = productProvider.findProdById(value.productId);
                                try{
                                  final orderId = const Uuid().v4();
                                  await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
                                    'orderId':orderId,
                                    'userId':user!.uid,
                                    'productId':value.productId,
                                    'price':(getCurrProduct.isOnSale
                                        ? getCurrProduct.salePrice
                                        :getCurrProduct.price ) * value.quantity,
                                    'totalPrice': total,
                                    'quantity':value.quantity,
                                    'imageUrl':getCurrProduct.imageUrl,
                                    'userName': user.displayName,
                                    'orderDate':Timestamp.now(),

                                  });
                                  setState(() {
                                    isLoading = false;
                                  });
                                  await cartProvider.clearOnlineCart();
                                  cartProvider.clearLocalCart();
                                  toastMsg(msg: 'Your order has been placed');
                                 await ordersProvider.fetchOrders();
                                }catch(error){
                                  setState(() {
                                    isLoading = false;
                                  });
                                  GlobalMethods.showErrorDialog(context: context, content: error.toString());
                                }finally{
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              });

                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.green),
                              child: Text(
                                'Order Now',
                                style: textTheme.titleMedium,
                              ),
                            ),
                          ),
                          Text(
                            'Total: \$${total.toStringAsFixed(1)}',
                            style: textTheme.titleMedium,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItemsList.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                              value: cartItemsList[index],
                              child: CartWidget(
                                q: cartItemsList[index].quantity,
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
