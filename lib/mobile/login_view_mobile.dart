import 'package:budget_app/components.dart';
import 'package:budget_app/view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_button/sign_button.dart';

class LoginViewMobile extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final viewModelProvider = ref.watch(viewModel);
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: deviceHeight / 5.5),
              Image.asset('assets/logo.png', fit: BoxFit.contain, width: 210.0),
              SizedBox(height: 30.0),
              SizedBox(
                width: 350.0,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  controller: emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    hintText: 'Email',
                    hintStyle: GoogleFonts.openSans(),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              // password
              SizedBox(
                width: 350.0,
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  textAlign: TextAlign.center,
                  controller: passwordController,
                  obscureText: viewModelProvider.isObscure,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    prefixIcon: IconButton(
                      icon: Icon(
                        viewModelProvider.isObscure
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      onPressed: () {
                        viewModelProvider.toggleObscure();
                      },
                    ),
                    hintText: 'Password',
                    hintStyle: GoogleFonts.openSans(),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150.0,
                    height: 50.0,
                    child: MaterialButton(
                      onPressed: () async {
                        await viewModelProvider.createUserWithEmailAndPassword(
                          context,
                          emailController.text,
                          passwordController.text,
                        );
                      },
                      child: OpenSans(
                        text: 'Register',
                        size: 20.0,
                        color: Colors.white,
                      ),
                      splashColor: Colors.grey,
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    'or',
                    style: GoogleFonts.pacifico(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  SizedBox(
                    width: 150.0,
                    height: 50.0,
                    child: MaterialButton(
                      child: OpenSans(
                        text: 'Login',
                        size: 20.0,
                        color: Colors.white,
                      ),
                      splashColor: Colors.grey,
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () async {
                        await viewModelProvider.signInWithEmailAndPassword(
                          context,
                          emailController.text,
                          passwordController.text,
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              // Google sign in button
              SignInButton(
                buttonType: ButtonType.google,
                buttonSize: ButtonSize.medium,
                btnColor: Colors.black,
                btnTextColor: Colors.white,
                onPressed: () async {
                  if (kIsWeb) {
                    await viewModelProvider.signInWithGoogleWeb(context);
                  } else {
                    await viewModelProvider.signInWithGoogleMobile(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
