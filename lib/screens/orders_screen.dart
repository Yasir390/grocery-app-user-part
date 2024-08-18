import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/orders_provider.dart';
import '../widgets/orders_widget.dart';
import 'empty_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  static const String routeName = '/OrdersScreen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;

    final ordersProvider = Provider.of<OrderProvider>(context);
    final ordersList = ordersProvider.getOrders;

    return FutureBuilder(
      future: ordersProvider.fetchOrders(),
      builder: (context, snapshot) {
        return ordersList.isEmpty? const EmptyScreen():Scaffold(
          appBar: AppBar(
            title: Text(
              'Your orders (${ordersList.length})',
              style: textTheme.titleLarge,
            ),

          ),
          body: ListView.separated(
            itemCount: ordersList.length,
            itemBuilder: (context, index) {
              return  ChangeNotifierProvider.value(
                  value: ordersList[index],
                  child: const OrdersWidget());
            },
            separatorBuilder: (context, index) {
              return const Divider(
                thickness: 1.9,
              );
            },

          ),
        );
      },
    );
  }
}
