import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/auth/register_screen.dart';
import 'package:grocery_app/screens/fetch_screen.dart';
import '../../const/const.dart';
import '../../const/firebase_const.dart';
import '../../services/global_methods.dart';
import '../../widgets/buttons/forget_pass_btn.dart';
import '../../widgets/buttons/google_button.dart';
import '../../widgets/buttons/sign_in_button.dart';
import '../../widgets/divider_signin_screen_widget.dart';
import '../../widgets/swiper_widget.dart';
import '../bottom_nav_screen.dart';
import '../loading_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/loginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      try{
        setState(() {
          isLoading = true;
        });
        await authInstance.signInWithEmailAndPassword(
          email: _emailController.text.toLowerCase().trim(),
          password: _passController.text.trim(),
        ).then((value) =>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FetchScreen(),)) );
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
    //final width = MediaQuery.of(context).size.width;
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
                        height: height * 0.11,
                      ),
                      Text(
                        'Welcome Back',
                        style: textTheme.headlineMedium!
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        'Sign in to continue',
                        style:
                            textTheme.titleMedium!.copyWith(color: Colors.white),
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      TextFormField(
                        controller: _emailController,
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
                        height: height * 0.02,
                      ),
                      TextFormField(
                        controller: _passController,
                        focusNode: _passFocusNode,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        cursorColor: Colors.white,
                        obscureText: isObscure,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Please enter valid password';
                          } else {
                            return null;
                          }
                        },
                        onEditingComplete: () {
                          _submitFormOnLogin();
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                              child: Icon(
                                isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              )),
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.white),
                          border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: ForgetPasswordBtn(textTheme: textTheme)),
                      ReusableElevatedBtn(
                        buttonTitle: 'Sign In',
                        onPressed: () {
                          _submitFormOnLogin();
                        },
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      GoogleBtn(
                        textTheme: textTheme,
                      ),
                      // Divider(thickness: 2,),
                      DividerSignInScreen(textTheme: textTheme),
                      ReusableElevatedBtn(
                        buttonTitle: 'Continue as guest',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const FetchScreen(),));
                        },
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: textTheme.titleMedium!
                                .copyWith(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RegisterScreen.routeName);
                            },
                            child: Text(
                              'Sign up',
                              style: textTheme.titleMedium!
                                  .copyWith(color: Colors.blue),
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
