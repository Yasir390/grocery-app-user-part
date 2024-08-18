import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/screens/fetch_screen.dart';

import '../../const/firebase_const.dart';
import '../../screens/bottom_nav_screen.dart';
import '../../services/global_methods.dart';

class GoogleBtn extends StatelessWidget {
  const GoogleBtn({super.key, required this.textTheme});

  final TextTheme textTheme;

  //final VoidCallback onTap;

  Future<void> googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await authInstance.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));

          if (authResult.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(authResult.user!.uid)
                .set({
              'id': authResult.user!.uid,
              'name': authResult.user!.displayName,
              'email': authResult.user!.email,
              'shipping-address': '',
              'userWish': [],
              'userCart': [],
              'createdAt': Timestamp.now(),
            });
          }
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FetchScreen(),
              ));
        } on FirebaseException catch (error) {
          GlobalMethods.showErrorDialog(
              context: context, content: error.message.toString());
        } catch (error) {
          GlobalMethods.showErrorDialog(
              context: context, content: error.toString());
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        googleSignIn(context);
      },
      child: Container(
        height: kBottomNavigationBarHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.black),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Image(
              image: AssetImage('assets/logo/google.png'),
              height: 45,
              width: 45,
            ),
            Text(
              'Sign in with Google',
              style: textTheme.titleMedium!.copyWith(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
