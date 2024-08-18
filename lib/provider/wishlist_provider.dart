import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../const/firebase_const.dart';
import '../models/wishlist_model.dart';

class WishlistProvider with ChangeNotifier {

 final Map<String, WishListModel> _wishlistItems = {};

  Map<String, WishListModel> get getWishlistItems {
    return _wishlistItems;
  }

 Future<void> fetchWishlist()async{
   final User? user = authInstance.currentUser;
   final DocumentSnapshot userDoc =await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
   if(userDoc == null){
     return;
   }
   final leng = userDoc.get('userWish').length;
   for(var i=0;i<=leng;i++){
     _wishlistItems.putIfAbsent(userDoc.get('userWish')[i]['productId'], () =>
       WishListModel(
           id: userDoc.get('userWish')[i]['wishId'],
           productId: userDoc.get('userWish')[i]['productId']
       )
   );
     notifyListeners();
   }
   //  _cartItems;
   // notifyListeners();
 }

 Future<void> removeFromWishlist({
   required String wishId,required String productId
 }) async {

   final User? user = authInstance.currentUser;
   await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
     'userWish':FieldValue.arrayRemove([
       {
         'wishId':wishId,
         'productId':productId,
       }
     ]),

   });
   _wishlistItems.remove(productId);
   fetchWishlist();
   notifyListeners();
 }


 // void addRemoveProductToWishlist({required String productId}) {
  //   if (_wishlistItems.containsKey(productId)) {
  //     removeOneItem(productId);
  //   } else {
  //     _wishlistItems.putIfAbsent(
  //         productId, () => WishListModel(
  //       id: DateTime.now().toString(),
  //       productId: productId,));
  //   }
  //   notifyListeners();
  // }

  // void removeOneItem(String productId) {
  //   _wishlistItems.remove(productId);
  //   notifyListeners();
  // }
 Future<void> clearOnlineWishlist()async{
   final User? user = authInstance.currentUser;
   await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
     'userWish':[]
   });
   _wishlistItems.clear();
   notifyListeners();
 }


  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }


}