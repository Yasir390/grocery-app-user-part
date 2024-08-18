import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/const/firebase_const.dart';
import 'package:grocery_app/models/order_model.dart';

class OrderProvider with ChangeNotifier{
 static List<OrderModel> _orders = [];
 
  List<OrderModel> get getOrders{
    return _orders;
  }

   void clearLocalOrders(){
    _orders.clear();
    notifyListeners();
   }
 Future<void> fetchOrders()async{
   _orders = [];
   User? user = authInstance.currentUser;
   // _productsList.clear();
   await FirebaseFirestore.instance.collection('orders').where('userId',isEqualTo: user!.uid).get().then((QuerySnapshot snapshot) {
     for (var element in snapshot.docs) {
       _orders.insert(0,
        OrderModel(
              orderId: element.get('orderId'),
              userId: element.get('userId'),
              productId: element.get('productId'),
              userName: element.get('userName'),
              price: element.get('price').toString(),
              imageUrl: element.get('imageUrl'),
              quantity: element.get('quantity').toString(),
              orderDate: element.get('orderDate'),
            ));
       notifyListeners();
     }
   });
   //  notifyListeners();
 }


}