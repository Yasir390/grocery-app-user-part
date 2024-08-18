import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/categories_product_screen.dart';
import '../theme/theme_provider.dart';

class CategoriesWidget extends StatelessWidget {

  const CategoriesWidget({super.key, required this.passedColor, required this.categoriesName, required this.imgPath});

 final Color passedColor;
 final String categoriesName,imgPath;


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final themeState = Provider.of<ThemeProvider>(context);
    final Color color = themeState.getDarkTheme? Colors.white:Colors.black;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context,  CategoriesProductScreen.routeName,arguments: categoriesName );
      },
      child: Container(
        height: width*0.6,
        //width: width*0.4,
        decoration: BoxDecoration(
            color: passedColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: passedColor.withOpacity(0.7),
                width:2
            )
        ),
        child: Column(
          children: [
            Container(
              height: width*0.3,
              width: width*0.3,
              decoration:  BoxDecoration(
                image: DecorationImage(image:
                AssetImage(imgPath),
                    fit: BoxFit.contain
                ),

              ),
            ),
            Text(categoriesName,style: Theme.of(context).textTheme.titleMedium,)
          ],
        ),
      ),
    );
  }
}
