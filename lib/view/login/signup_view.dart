import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/common_widget/round_textfield.dart';
import 'package:fitness/view/login/complete_profile_view.dart';
import 'package:fitness/view/login/login_view.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class _SignUpViewState extends State<SignUpView> {
  bool isCheck = false;
  bool _isPasswordVisible = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey there,",
                  style: TextStyle(color: TColor.gray, fontSize: 16),
                ),
                Text(
                  "Create an Account",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                RoundTextField(
                  hitText: "First Name",
                  icon: "assets/img/user_text.png",
                  controller: firstNameController,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  hitText: "Last Name",
                  icon: "assets/img/user_text.png",
                  controller: lastNameController,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  hitText: "Email",
                  icon: "assets/img/email.png",
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  hitText: "Password",
                  icon: "assets/img/lock.png",
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  rigtIcon: TextButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
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
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isCheck = !isCheck;
                        });
                      },
                      icon: Icon(
                        isCheck
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_outlined,
                        color: TColor.gray,
                        size: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child:  Text(
                          "By continuing you accept our Privacy Policy and\nTerm of Use",
                          style: TextStyle(color: TColor.gray, fontSize: 10),
                        ),
                     
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.4,
                ),
                //RoundButton(title: "Register", onPressed: () {
                  
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => const CompleteProfileView()  ));
                //}),
                RoundButton(
                title: "Register",
                onPressed: () async {
                  if (!isCheck) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please accept the terms to continue.")),
                    );
                    return;
                  }

                  try {
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: passwordController.text,
                    );

                    // Optional: Save first & last name in Firestore or pass to next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompleteProfileView(
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          email: emailController.text.trim(),
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Registration failed: ${e.toString()}")),
                    );
                  }
                },
              ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                // Row(
                //   // crossAxisAlignment: CrossAxisAlignment.,
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
                //       onTap: _googleLogin,
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

                //      SizedBox(
                //       width: media.width * 0.04,
                //     ),

                //     GestureDetector(
                //       onTap: () {},
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
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Login",
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

  // Google Login Function
  Future<void> _googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the login process
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Optionally save first & last name in Firestore or pass to next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompleteProfileView(
            firstName: googleUser.displayName?.split(' ')[0] ?? '',
            lastName: googleUser.displayName?.split(' ')[1] ?? '',
            email: googleUser.email,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google login failed: $e")));
    }
  }
}


