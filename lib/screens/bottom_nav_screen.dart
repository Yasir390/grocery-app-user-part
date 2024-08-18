import 'package:flutter/material.dart';
import 'package:grocery_app/screens/user.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../provider/products_provider.dart';
import '../theme/theme_provider.dart';
import 'cart_screen.dart';
import 'categories_screen.dart';
import 'home_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {

  List<Map<String,dynamic>> pages = [
    {'page':const HomeScreen(),'title':'Home Screen'},
    {'page':const CategoriesScreen(),'title':'Categories Screen'},
    {'page':const CartScreen(),'title':'Cart Screen'},
    {'page':const UserScreen(),'title':'User Screen'},

  ];

  int currentIndex = 0;
  void changeIndex(int index){
    currentIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context).getDarkTheme;
    // final productsProvider = Provider.of<ProductsProvider>(context,listen: false);
    // productsProvider.fetchProducts();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(pages[currentIndex]['title']),
      // ),
      body:pages[currentIndex]['page'] ,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor:themeProvider?  Colors.lightBlue.shade200:Colors.black,
        unselectedItemColor:themeProvider?Colors.white : Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: themeProvider? Colors.black:Colors.white,

        onTap: (index) {
          setState(() {
            changeIndex(index);
          });
        },
          items:<BottomNavigationBarItem>  [
            BottomNavigationBarItem(icon: Icon(currentIndex == 0 ? Icons.home:Icons.home_outlined),label: 'Home'),
            BottomNavigationBarItem(icon: Icon(currentIndex == 1 ? Icons.category:Icons.category_outlined),label: 'Categories'),
            BottomNavigationBarItem(icon:
            Consumer<CartProvider>(
              builder: (BuildContext context, cartProvider, Widget? child) {
                return Badge(
                    label:  Text(cartProvider.getCartItems.length.toString()),child: Icon(currentIndex == 2 ? Icons.shopping_cart:Icons.shopping_cart_outlined));
              },
            ),label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(currentIndex == 3 ?Icons.person:Icons.person_outline),label: 'Person'),
          ],
      ),
    );
  }
}
