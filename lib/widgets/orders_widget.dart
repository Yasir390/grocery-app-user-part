import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/models/order_model.dart';
import 'package:grocery_app/provider/products_provider.dart';
import 'package:provider/provider.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({super.key});

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {

  late String orderDateToShow;

  @override
  void didChangeDependencies() {
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();//convert TimeStamp to date format
    orderDateToShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrderModel>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProdById(ordersModel.productId);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
        leading: FancyShimmerImage(
          imageUrl:getCurrProduct.imageUrl,
          height: height * 0.1,
          width: width * 0.2,
          boxFit: BoxFit.fill,
        ),
        title: Text(
          '${getCurrProduct.title} x${ordersModel.quantity}' ,
          style: textTheme.titleLarge,
        ),
        subtitle: Text(
          'Paid: \$${(ordersModel.price).toString()}',
          style: textTheme.titleSmall,
        ),
        trailing: Text(
          orderDateToShow,
          style: textTheme.titleMedium,
        ),
    );










    //   SizedBox(
    //   height: 100,
    //   child: Material(
    //     color: Colors.blue.withOpacity(0.2),
    //      borderRadius:  BorderRadius.circular(15),
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Row(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               FancyShimmerImage(
    //                 imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXgZDmjRAXgyEi2xTlUkK-rpxtZ8as87cjJw&s',
    //                 height: height*0.1,
    //                 width: width*0.22,
    //                 boxFit: BoxFit.fill,
    //               ),
    //               SizedBox(
    //                 width: width*0.04,
    //               ),
    //               Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Text('Title x12',style: textTheme.titleLarge,),
    //                   Text('Paid: \$12.8',style: textTheme.titleSmall,),
    //                 ],
    //               ),
    //             ],
    //           ),
    //
    //           Text('03/08/2022',style: textTheme.titleMedium,),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
