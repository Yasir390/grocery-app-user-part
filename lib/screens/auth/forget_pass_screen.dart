import 'dart:developer';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../const/const.dart';
import '../../const/firebase_const.dart';
import '../../const/flutter_toast.dart';
import '../../services/global_methods.dart';
import '../../widgets/buttons/forget_pass_btn.dart';
import '../../widgets/buttons/google_button.dart';
import '../../widgets/buttons/sign_in_button.dart';
import '../../widgets/divider_signin_screen_widget.dart';
import '../../widgets/swiper_widget.dart';
import '../loading_screen.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});
  static const String routeName = '/forgetPassScreen';

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final _emailController = TextEditingController();


  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  _submitFormOnResetPass() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      try{
        setState(() {
          isLoading = true;
        });
        await authInstance.sendPasswordResetEmail(email: _emailController.text.toLowerCase().trim());
        toastMsg(msg: 'Please check your mail');
        setState(() {
          isLoading = false;
        });
      }on FirebaseException catch(error){
        setState(() {
          isLoading = false;
        });
        GlobalMethods.showErrorDialog(context: context, content: error.message.toString());

      }catch(error){
        setState(() {
          isLoading = false;
        });
        GlobalMethods.showErrorDialog(context: context, content: error.toString());

      }finally{
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    //  final isDark = Utils(context).getTheme;

    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: Stack(
          children: [
            const SwiperWidget(),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height*0.11,
                      ),
                      Text('Forget password',style: textTheme.headlineMedium!.copyWith(
                          color: Colors.white
                      ),),
                      SizedBox(
                        height: height*0.04,
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.white,
                        validator: (value) {
                          if(value!.isEmpty || !value.contains('@')){
                            return 'Please enter a valid email address';
                          }else{
                            return null;
                          }
                        },
                        onEditingComplete: () {
                          _submitFormOnResetPass();
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: Consts.inputDecoration(hintText: 'Email'),

                      ),
                      SizedBox(
                        height: height*0.02,
                      ),

                      ReusableElevatedBtn(
                        buttonTitle: 'Reset now',
                        onPressed: () {
                          _submitFormOnResetPass();
                        },
                      ),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

