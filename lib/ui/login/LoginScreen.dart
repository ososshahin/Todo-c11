import 'package:flutter/material.dart';
import 'package:todo_c11/ui/ValiationUtils.dart';
import 'package:todo_c11/ui/common/TextFormField.dart';
import 'package:todo_c11/ui/register/RegisterScreen.dart';
import 'package:todo_c11/ui/utils.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = 'login';

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
  }
}
