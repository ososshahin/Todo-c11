import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_c11/DialogUtils.dart';
import 'package:todo_c11/firebaseauthutils.dart';
import 'package:todo_c11/ui/ValiationUtils.dart';
import 'package:todo_c11/ui/common/TextFormField.dart';
import 'package:todo_c11/ui/home/HomeScreen.dart';
import 'package:todo_c11/ui/register/RegisterScreen.dart';
import 'package:todo_c11/ui/utils.dart';

import '../../providers/appauthprovider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.routeMainColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Form(
            key: formKey ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 48,
                ),
                Image.asset(
                  getImagePath('route_logo.png'),
                  width: double.infinity,
                ),
                AppFormField(
                  title: "Email Address",
                  hint: 'please enter Email Address',
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if(text?.trim().isEmpty == true){
                      return "Please enter your email";
                    }
                    if(!isValidEmail(text!)){
                      return "please enter valid email";
                    }

                    return null;
                  },
                  controller: email,
                ),
                AppFormField(
                  title: "Password",
                  hint: 'please enter Password',
                  keyboardType: TextInputType.text,
                  securedPassword: true,
                  validator: (text) {
                    if(text?.trim().isEmpty == true){
                      return "Please enter your password";
                    }
                    if(!isValidPassword(text!)){
                      return "password at least 6 chars";
                    }

                    return null;
                  },
                  controller: password,
                ),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 18),
                    ),
                    onPressed: () {
                      login();
                    },
                    child: Text(
                      'Login',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.routeMainColor),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don’t have an account? ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white
                    ),),
                    TextButton(onPressed: (){
                      Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
                    }, child: Text("Create Account",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                      decoration: TextDecoration.underline,

                    ),))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() {
    // validate form
    formKey.currentState?.validate();
    signin();

  }

  void signin() async{
    var authProvider = Provider.of<AppAuthProvider>(context,listen: false);
    try {
      showLoadingDialog(context, 'Please wait....',isCancelable: false);
      final appUser = await authProvider.signInWithEmailAndPassword(email.text, password.text
      );
      if(appUser==null){
        hideLoadingDialog(context);
        showMessageDialog(context, 'Something went wrong',posButtonTitle: 'Try again',
            posButtonAction: () =>signin);
      }else{
      hideLoadingDialog(context);
      showMessageDialog(context, 'Logged in successfully',posButtonTitle: 'ok',
        posButtonAction: () => Navigator.pushReplacementNamed(context, HomeScreen.routeName),);
     }
    } on FirebaseAuthException catch (e) {
      String message = 'Something went wrong';
      if (e.code == FirebaseAuthCodes().userNotFound
          ||e.code == FirebaseAuthCodes().wrongPassword
          ||e.code == FirebaseAuthCodes().invalidCredential) {
        message='Invalid email or password';
        hideLoadingDialog(context);
        showMessageDialog(context, message,posButtonTitle: 'ok',posButtonAction: () {
          Navigator.pop(context);
        },);
      }
    }catch (e) {
      hideLoadingDialog(context);
      String message = 'Something went wrong';
      showMessageDialog(context, message,posButtonTitle: 'Try again',posButtonAction:() {
        login();
      },);
  }
}}
