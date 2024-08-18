import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/fetch_screen.dart';
import '../../const/const.dart';
import '../../const/firebase_const.dart';
import '../../const/flutter_toast.dart';
import '../../services/global_methods.dart';
import '../../widgets/buttons/forget_pass_btn.dart';
import '../../widgets/buttons/sign_in_button.dart';
import '../../widgets/swiper_widget.dart';
import '../loading_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/registerScreen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool isLoading = false;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _addressController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  _submitFormOnRegister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      _formKey.currentState!.save();
      setState(() =>isLoading = true);

      try{
        // user registration
       await authInstance.createUserWithEmailAndPassword(
          email: _emailController.text.toLowerCase().trim(),
          password: _passController.text.trim(),
        );
        // upload data to firebase firestore
       final User? user = authInstance.currentUser;
       final uId = user!.uid;

       user.updateDisplayName(_nameController.text);
       user.reload();

       await FirebaseFirestore.instance.collection('users').doc(uId).set(
         {
           'id':uId,
           'name':_nameController.text.toString(),
           'email':_emailController.text.toString().trim(),
           'shipping-address':_addressController.text.toString(),
           'userWish':[],
           'userCart':[],
           'createdAt':Timestamp.now(),
         }
       ).onError((error, stackTrace) =>
           GlobalMethods.showErrorDialog(context: context,
               content: error.toString()));
       if(mounted){
         Navigator.pushReplacement(context,
             MaterialPageRoute(builder: (context) => const FetchScreen(),));
       }

       // toastMsg(msg: 'Account Create Successfully');

      }on FirebaseException catch(error){
        setState(() =>isLoading = false);
        if(mounted){
          GlobalMethods.showErrorDialog(
              context: context,
              content: error.message.toString());
        }


      }
      catch(error){
        toastMsg(msg: error.toString());
        setState(() =>isLoading = false);
      }finally{
        setState(() =>isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
 //   final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    //  final isDark = Utils(context).getTheme;

    return Scaffold(
      body: LoadingManager(// this is Loading Widget
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
                      Text('Welcome',style: textTheme.headlineMedium!.copyWith(
                          color: Colors.white
                      ),),
                      Text('Sign up to continue',style: textTheme.titleMedium!.copyWith(
                          color: Colors.white
                      ),),SizedBox(
                        height: height*0.04,
                      ),
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.white,
                        validator: ( value) {
                         return (value!.isEmpty || value.length <3) ?  'Please enter full name' : null;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: Consts.inputDecoration(hintText: 'Full Name'),
                      ),
                      SizedBox(
                        height: height*0.02,
                      ),TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.white,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address';
                          } else {
                            return null;
                          }
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_passFocusNode);
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: Consts.inputDecoration(hintText: 'Email'),
                      ),
                      SizedBox(
                        height: height*0.02,
                      ),
                      TextFormField(
                        controller: _passController,
                        focusNode: _passFocusNode,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.white,
                        obscureText: isObscure,
                        validator: (value) {
                          if(value!.isEmpty || value.length <6 ){
                            return 'Please enter valid password';
                          }else{
                            return null;
                          }
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_addressFocusNode);
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration:  InputDecoration(
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                              child: Icon(isObscure?Icons.visibility:Icons.visibility_off,color: Colors.white,)),
                          hintText: 'Password',
                          hintStyle:  const TextStyle(color: Colors.white),
                          border: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white
                              )
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white
                              )
                          ),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white
                              )
                          ),
                        ),

                      ),
                      SizedBox(
                        height: height*0.01,
                      ),
                      TextFormField(
                        controller: _addressController,
                        focusNode: _addressFocusNode,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        cursorColor: Colors.white,
                        validator: (value) {
                          return (value!.isEmpty || value.length <3) ?  'Please enter shipping address' : null;

                        },
                        onEditingComplete: () {
                          _submitFormOnRegister();
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: Consts.inputDecoration(hintText: 'Shipping Address'),
                      ),
                      SizedBox(
                        height: height*0.02,
                      ),
                      ForgetPasswordBtn(textTheme: textTheme),
                      ReusableElevatedBtn(
                        buttonTitle: 'Sign up',
                        onPressed: () {
                          _submitFormOnRegister();
                        },
                      ),
                      SizedBox(
                        height: height*0.01,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already an user?",
                            style: textTheme.titleMedium!.copyWith(
                                color: Colors.white
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                             Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                            },

                            child: Text('Sign in',
                              style: textTheme.titleMedium!.copyWith(
                                  color: Colors.blue
                              ),
                            ),
                          )
                        ],
                      )
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
