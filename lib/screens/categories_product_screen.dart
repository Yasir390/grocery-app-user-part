import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products_model.dart';
import '../provider/products_provider.dart';
import '../widgets/empty_product_widget.dart';
import '../widgets/feed_items_widget.dart';

class CategoriesProductScreen extends StatefulWidget {
  const CategoriesProductScreen({super.key});
  static const String routeName = '/categoriesProductScreen';


  @override
  State<CategoriesProductScreen> createState() => _CategoriesProductScreenState();
}

class _CategoriesProductScreenState extends State<CategoriesProductScreen> {

  final _searchTextController = TextEditingController();
  final _searchTextFocusNode = FocusNode();

  List<ProductModel> listProductSearch = [];

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    final productProvider = Provider.of<ProductsProvider>(context);
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    List<ProductModel> productByCat = productProvider.findByCategory(catName);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child:Scaffold(
        appBar: AppBar(
          title: Text(catName,
            style:textTheme.titleLarge,
          ),
        ),
        body:productByCat.isEmpty
            ?const EmptyProductWidget()
            :  SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: kBottomNavigationBarHeight,
                  child: TextField(
                    controller:_searchTextController ,
                    focusNode:_searchTextFocusNode ,
                    cursorColor:primaryColor,
                    onChanged: (value) {
                      setState(() {
                        listProductSearch = productProvider.searchQuery(value);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "What's is in your mind?",
                      hintStyle: TextStyle(
                          color: primaryColor
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _searchTextController.clear();
                          _searchTextFocusNode.unfocus();
                        },
                        icon: Icon(Icons.clear,
                          color: _searchTextFocusNode.hasFocus? Colors.red:primaryColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Colors.orange
                          )
                      ),
                      enabledBorder:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Colors.orange
                          )
                      ),
                    ),
                  ),
                ),
              ),
              _searchTextController.text.isNotEmpty && listProductSearch.isEmpty
              ? const EmptyProductWidget(text: 'No products found',)
                  : GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,

                  // jodi singleChildScrollView or Listview er modde GridView use korte hoi
                  // tahole physics r shrinkWrap ey properties use korte hbe r tkn Gridview k
                  // Expanded or Flexible diye wrap kora jabe na
                  crossAxisCount: 2,
                  //crossAxisSpacing: 10,
                  padding: EdgeInsets.zero,
                  childAspectRatio: width / (height * 0.8),
                  children: List.generate(
                      _searchTextController.text.isNotEmpty
                          ?listProductSearch.length
                          : productByCat.length, (index) {
                    return  ChangeNotifierProvider.value(
                      value:_searchTextController.text.isNotEmpty
                          ?listProductSearch[index]
                          :productByCat[index],
                      child: const FeedsWidget(
                        // imageUrl: allProducts[index].imageUrl,
                        // title: allProducts[index].title,
                      ),
                    );
                  })),
            ],
          ),
        ),
      ),
    );
  }
}
