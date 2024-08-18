import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../widgets/wishlist_widget.dart';
import 'empty_screen.dart';

class WishListScreen extends StatefulWidget {
  static const String routeName = '/wishlistScreen';
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemsList = wishlistProvider.getWishlistItems.values.toList().reversed.toList();

    // bool isEmpty = false;
    return wishlistItemsList.isEmpty?const EmptyScreen(): Scaffold(
      appBar: AppBar(
        title: Text('WishList (${wishlistItemsList.length})',style:textTheme.titleLarge ,),
        actions: [
          IconButton(
            onPressed: () {
              GlobalMethods.showLogoutDialog(
                context: context,
                title: 'Delete Wishlist',
                content: 'Are you sure?',
                actionText: 'Yes',
                onPressed: () async {
                  Navigator.pop(context);
                  await wishlistProvider.clearOnlineWishlist();
                   wishlistProvider.clearLocalWishlist();
                },
              );
            },
            icon: const Icon(Icons.delete_outline),
          )
        ],
      ),

      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(wishlistItemsList.length, (index) => ChangeNotifierProvider.value(
            value: wishlistItemsList[index],
            child: const WishListWidget())),
      ),

    );
  }


}
