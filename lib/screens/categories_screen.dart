import 'package:flutter/material.dart';
import '../services/utils.dart';
import '../widgets/categories_widget.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Map<String, dynamic>> catInfo = [
    {'imgPath': 'assets/images/fruits.jpg', 'catText': 'Fruits'},
    {'imgPath': 'assets/images/vegetable.jpg', 'catText': 'Vegetable'},
    {'imgPath': 'assets/images/brocollijpg.jpg', 'catText': 'Herbs'},
    {'imgPath': 'assets/images/nuts.jpg', 'catText': 'Nuts'},
    {'imgPath': 'assets/images/spices.jpg', 'catText': 'Spices'},
    {'imgPath': 'assets/images/grains.jpg', 'catText': 'Grains'}
  ];

  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.teal
  ];

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Categories',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // jodi singleChildScrollView or Listview er modde GridView use korte hoi
                  // tahole physics r shrinkWrap ey properties use korte hbe r tkn Gridview k
                  // Expanded or Flexible diye wrap kora jabe na
                  crossAxisCount: 2,
                  childAspectRatio: 240 / 250,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(6, (index) {
                    return CategoriesWidget(
                      passedColor: colorList[index],
                      categoriesName: catInfo[index]['catText'],
                      imgPath: catInfo[index]['imgPath'],
                    );
                  }),
                ),
              ),
            ],
          ),
        ));
  }
}
