import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/const/firebase_const.dart';
import 'package:grocery_app/const/flutter_toast.dart';
import 'package:uuid/uuid.dart';

class GlobalMethods {
  static Future<void> showLogoutDialog(
      {required BuildContext context,
      required String title,
      required String content,
      required String actionText,
      required VoidCallback onPressed}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            TextButton(
              onPressed: onPressed,
              child: Text(actionText),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showErrorDialog(
      {required BuildContext context,
        required String content}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> addToCart(BuildContext context,
      {required String productId,
    required int quantity})async{

    final User? user = authInstance.currentUser;
    final uid = user!.uid;
    final cartId = const Uuid().v4(); //generate random id
    try{
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'userCart':FieldValue.arrayUnion([
         {
           'cartId':cartId,
           'productId':productId,
           'quantity':quantity,
         }
        ])
      }).then((value) {
        toastMsg(msg: 'Cart added');
      });
    }catch(e){
      showErrorDialog(context: context, content: e.toString());
    }
  }

  static Future<void> addToWishlist(BuildContext context,
      {required String productId,
    })async{

    final User? user = authInstance.currentUser;
    final uid = user!.uid;
    final wishId = const Uuid().v4(); //generate random id
    try{
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'userWish':FieldValue.arrayUnion([
         {
           'wishId':wishId,
           'productId':productId,
         }
        ])
      }).then((value) {
        toastMsg(msg: 'Added to wishlist');
      });
    }catch(e){
      showErrorDialog(context: context, content: e.toString());
    }
  }

}
