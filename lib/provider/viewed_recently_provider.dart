import 'package:flutter/foundation.dart';

import '../models/viewed_model.dart';

class ViewedRecentlyProvider with ChangeNotifier {
  final Map<String, ViewedRecentlyModel> _viewedProdListItems = {};

  Map<String, ViewedRecentlyModel> get getViewedProdListItems {
    return _viewedProdListItems;
  }

  void addProductToHistory({required String productId}) {
    _viewedProdListItems.putIfAbsent(
      productId,
      () => ViewedRecentlyModel(
        id: DateTime.now().toString(),
        productId: productId,
      ),
    );
    notifyListeners();
  }

  void clearHistory() {
    _viewedProdListItems.clear();
    notifyListeners();
  }
}
