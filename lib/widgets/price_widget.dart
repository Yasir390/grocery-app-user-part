import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({super.key, required this.salePrice, required this.price, required this.textPrice, required this.isOnSale});

  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    double userPrice = isOnSale? salePrice:price;
    return FittedBox(
      child: Row(
        children: [
          Text('\$${(userPrice * int.parse(textPrice)).toStringAsFixed(2)}',
          style:textTheme.titleSmall!.copyWith(
            color: Colors.green
          ) ,
          ),
          SizedBox(
            width: width*0.025,
          ),
          Visibility(
            visible: isOnSale ? true : false,
            child: Text(
              '\$${(price * int.parse(textPrice)).toStringAsFixed(2)}',
              style: textTheme.titleSmall!
                  .copyWith(decoration: TextDecoration.lineThrough),
            ),
          ),
        ],
      ),
    );
  }
}
