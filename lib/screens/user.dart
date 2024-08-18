import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/viewed_screen.dart';
import 'package:grocery_app/screens/wishlist_screen.dart';
import '../const/firebase_const.dart';
import '../services/global_methods.dart';
import '../widgets/listTile_widget_user_screen.dart';
import '../widgets/switch_listTile_widget.dart';
import 'auth/login_screen.dart';
import 'loading_screen.dart';
import 'orders_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  User? user = authInstance.currentUser;
  bool isLoading = false;
  String? _email;
  String? _name;
  String? _address;
  @override
  void initState() {
    getUserData();
  super.initState();
  }
  Future<void> getUserData()async{
    setState(() =>isLoading = true);

    if(user == null){
      setState(() =>isLoading = false);
      return;
    }
    try{
     String uId = user!.uid;
     final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uId).get();
     if(userDoc == null){
       return;
     }else{
       _email = userDoc.get('email');
       _name = userDoc.get('name');
       _address = userDoc.get('shipping-address');
       _addressController.text = userDoc.get('shipping-address');
     }
    }on FirebaseException catch(error){
      setState(() =>isLoading = false);
      GlobalMethods.showErrorDialog(context: context, content: error.message.toString());

    }catch(error){
      setState(() =>isLoading = false);
      GlobalMethods.showErrorDialog(context: context, content: error.toString());

    }finally{
      setState(() =>isLoading = false);
    }

  }
  @override
  Widget build(BuildContext context) {
  //  final themeProvider = Provider.of<ThemeProvider>(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: Expanded(
            child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15,top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(text:  TextSpan(
                    text: 'Hi, ',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Colors.cyan
                    ),
                    children: [
                      TextSpan(
                        text:_name ?? 'user', //check if null
                        style: Theme.of(context).textTheme.headlineLarge,
                        recognizer: TapGestureRecognizer()..onTap=() {
                          log('name pressed');
                        }
                      ),

                    ]
                  ),
                  ),
                  Text(_email ?? 'email', //check if null
                  style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ),
            ),
            SizedBox(
              height: height*0.02,
            ),
            const Divider(
              thickness: 2,
            ),
            SizedBox(
              height: height*0.02,
            ),

            ListTile(
              onTap: () {
                showAddressDialog();
              },
              title: Text('Address',style: Theme.of(context).textTheme.titleMedium,),
              leading:  Icon(Icons.abc,  color: Theme.of(context).iconTheme.color,),
              subtitle: Text(_address ??'City' ,style: Theme.of(context).textTheme.titleSmall,),
              trailing:  Icon(Icons.arrow_forward_ios_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            // ReusableListTileWidgetUserScreen(
            //   titleString: 'Address',
            //   leadingIconName: Icons.abc,
            //   onTap: () {
            //     showAddressDialog();
            //   },
            //   subTitleString: 'Chattogram',
            // ),
            ReusableListTileWidgetUserScreen(
              titleString: 'Orders',
              leadingIconName: Icons.shopping_bag,
              onTap: () {
                Navigator.pushNamed(context, OrdersScreen.routeName);
              },
            ),
            ReusableListTileWidgetUserScreen(
              titleString: 'WishList',
              leadingIconName: Icons.favorite,
              onTap: () {
                Navigator.pushNamed(context, WishListScreen.routeName);
              },
            ),
            ReusableListTileWidgetUserScreen(
              titleString: 'Viewed',
              leadingIconName: Icons.remove_red_eye,
              onTap: () {
                Navigator.pushNamed(context, ViewedScreen.routeName);
              },
            ),
            ReusableListTileWidgetUserScreen(
              titleString: 'Forget Password',
              leadingIconName: Icons.lock_open,
              onTap: () {},
            ),
            const SwitchListTileWidget(),
            ReusableListTileWidgetUserScreen(
              titleString:user == null? 'Login': 'Logout',
              leadingIconName:user == null? Icons.login : Icons.logout,
              onTap: () {
                user == null
                    ? Navigator.pushReplacementNamed(context, LoginScreen.routeName)
                  : GlobalMethods.showLogoutDialog(
                  context: context,
                  title: 'Sign Out',
                  content: 'Are you sure?',
                  actionText: 'Yes',
                  onPressed: () {
                    authInstance.signOut().then((value) => Navigator.pushReplacementNamed(context, LoginScreen.routeName));
                  },
                );
              },
            ),
          ],
        )),
      ),
    );
  }
final TextEditingController _addressController = TextEditingController();
  Future<void> showAddressDialog() async {
   await showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Update'),
          content: TextFormField(
            controller:_addressController ,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                String uId = user!.uid;
                try{

                  await FirebaseFirestore.instance.collection('users').doc(uId).update({
                    'shipping-address': _addressController.text.toString()
                  });
                  setState(() {
                    _address = _addressController.text.toString();
                  });
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog

                }catch(error){
                  setState(() =>isLoading = false);
                  GlobalMethods.showErrorDialog(context: context, content: error.toString());

                }
              },
            ),
          ],
        );
      },
    );
  }

}

