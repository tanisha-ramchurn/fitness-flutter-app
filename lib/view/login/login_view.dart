import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/common_widget/round_textfield.dart';
import 'package:fitness/view/main_tab/main_tab_view.dart'; // Assuming MainTabView is the home screen
import 'package:fitness/view/login/signup_view.dart'; // Assuming MainTabView is the home screen

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isCheck = false;

  // Method for login
  void login() async {
    try {
      // Attempt login with Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // If successful, navigate to MainTabView
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainTabView()),
      );
    } on FirebaseAuthException catch (e) {
      // Show an error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: media.height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey there,",
                  style: TextStyle(color: TColor.gray, fontSize: 16),
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: emailController,
                  hitText: "Email",
                  icon: "assets/img/email.png",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: passwordController,
                  hitText: "Password",
                  icon: "assets/img/lock.png",
                  obscureText: true,
                  rigtIcon: TextButton(
                      onPressed: () {},
                      child: Container(
                          alignment: Alignment.center,
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            "assets/img/show_password.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: TColor.gray,
                          ))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot your password?",
                      style: TextStyle(
                          color: TColor.gray,
                          fontSize: 10,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
                const Spacer(),
                RoundButton(
                    title: "Login",
                    onPressed: () {
                      login();  // Call the login method
                    }),
                SizedBox(
                  height: media.width * 0.04,
                ),
                // Row(
                //   children: [
                //     Expanded(
                //         child: Container(
                //       height: 1,
                //       color: TColor.gray.withOpacity(0.5),
                //     )),
                //     Text(
                //       "  Or  ",
                //       style: TextStyle(color: TColor.black, fontSize: 12),
                //     ),
                //     Expanded(
                //         child: Container(
                //       height: 1,
                //       color: TColor.gray.withOpacity(0.5),
                //     )),
                //   ],
                // ),
                // SizedBox(
                //   height: media.width * 0.04,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     GestureDetector(
                //       onTap: () {
                //         // Implement Google sign-in
                //       },
                //       child: Container(
                //         width: 50,
                //         height: 50,
                //         alignment: Alignment.center,
                //         decoration: BoxDecoration(
                //           color: TColor.white,
                //           border: Border.all(
                //             width: 1,
                //             color: TColor.gray.withOpacity(0.4),
                //           ),
                //           borderRadius: BorderRadius.circular(15),
                //         ),
                //         child: Image.asset(
                //           "assets/img/google.png",
                //           width: 20,
                //           height: 20,
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       width: media.width * 0.04,
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         // Implement Facebook sign-in
                //       },
                //       child: Container(
                //         width: 50,
                //         height: 50,
                //         alignment: Alignment.center,
                //         decoration: BoxDecoration(
                //           color: TColor.white,
                //           border: Border.all(
                //             width: 1,
                //             color: TColor.gray.withOpacity(0.4),
                //           ),
                //           borderRadius: BorderRadius.circular(15),
                //         ),
                //         child: Image.asset(
                //           "assets/img/facebook.png",
                //           width: 20,
                //           height: 20,
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                // SizedBox(
                //   height: media.width * 0.04,
                // ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpView()),
                    );
            },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don’t have an account yet? ",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Register",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}