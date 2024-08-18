import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/viewed_recently_provider.dart';
import '../services/global_methods.dart';
import '../widgets/viewed_widget.dart';
import 'empty_screen.dart';

class ViewedScreen extends StatefulWidget {
  const ViewedScreen({super.key});

  static const String routeName = '/viewedScreen';

  @override
  State<ViewedScreen> createState() => _ViewedScreenState();
}

class _ViewedScreenState extends State<ViewedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    final viewedProdProvider = Provider.of<ViewedRecentlyProvider>(context);
    final viewedProdItemsList = viewedProdProvider.getViewedProdListItems.values.toList().reversed.toList();
   // bool isEmpty = false;
    return viewedProdItemsList.isEmpty?const EmptyScreen(): Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              GlobalMethods.showLogoutDialog(
                context: context,
                title: 'Delete Cart',
                content: 'Are you sure?',
                actionText: 'Yes',
                onPressed: () {
                  Navigator.pop(context);
                  viewedProdProvider.clearHistory();
                },
              );
            },
            icon: const Icon(Icons.delete_outline),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: viewedProdItemsList.length,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
              value: viewedProdItemsList[index],
          child: const ViewedWidget());
        },
      ),
    );
  }
}
