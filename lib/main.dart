import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/provider/cart_provider.dart';
import 'package:grocery_app/provider/orders_provider.dart';
import 'package:grocery_app/provider/products_provider.dart';
import 'package:grocery_app/provider/viewed_recently_provider.dart';
import 'package:grocery_app/provider/wishlist_provider.dart';
import 'package:grocery_app/screens/auth/forget_pass_screen.dart';
import 'package:grocery_app/screens/auth/login_screen.dart';
import 'package:grocery_app/screens/auth/register_screen.dart';
import 'package:grocery_app/screens/bottom_nav_screen.dart';
import 'package:grocery_app/screens/categories_product_screen.dart';
import 'package:grocery_app/screens/feeds_screen.dart';
import 'package:grocery_app/screens/fetch_screen.dart';
import 'package:grocery_app/screens/on_sale_screen.dart';
import 'package:grocery_app/screens/orders_screen.dart';
import 'package:grocery_app/screens/product_details_screen.dart';
import 'package:grocery_app/screens/viewed_screen.dart';
import 'package:grocery_app/screens/wishlist_screen.dart';
import 'package:grocery_app/theme/theme_data.dart';
import 'package:grocery_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ThemeProvider themeProvider = ThemeProvider();
  void getCurrentTheme()async{
    themeProvider.setDarkTheme = await themeProvider.themeSharedPrefs.getDarkTheme();
  }

  @override
  void initState() {
    getCurrentTheme();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return themeProvider;
        }),
        ChangeNotifierProvider(create:(context) => ProductsProvider(),),
        ChangeNotifierProvider(create:(context) => CartProvider(),),
        ChangeNotifierProvider(create:(context) => WishlistProvider(),),
        ChangeNotifierProvider(create:(context) => ViewedRecentlyProvider(),),
        ChangeNotifierProvider(create:(context) => OrderProvider(),),
      ],
      child: Consumer(
        builder: (BuildContext context, value, Widget? child) {
          return MaterialApp(
            title: 'Grocery App',
            debugShowCheckedModeBanner: false,
            theme: ThemeStyle.themeData(themeProvider.getDarkTheme, context),
            home: const FetchScreen(),
            routes: {
              OnSaleScreen.routeName: (context) => const OnSaleScreen(),
              FeedsScreen.routeName: (context) => const FeedsScreen(),
              ProductDetailsScreen.routeName: (context) => const ProductDetailsScreen(),
              WishListScreen.routeName: (context) => const WishListScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              ViewedScreen.routeName: (context) => const ViewedScreen(),
              RegisterScreen.routeName: (context) => const RegisterScreen(),
              LoginScreen.routeName: (context) => const LoginScreen(),
              ForgetPassScreen.routeName: (context) => const ForgetPassScreen(),
              CategoriesProductScreen.routeName: (context) => const CategoriesProductScreen(),
            },
          );
        },
      ),
    );
  }
}
