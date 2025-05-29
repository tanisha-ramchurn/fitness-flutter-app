import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/view/login/what_your_goal_view.dart';
import 'package:flutter/material.dart';

import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompleteProfileView extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;

  // ✅ Do NOT use `const` here if the values are NOT constant
  const CompleteProfileView({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
  }) : super(key: key);

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

String? selectedGender;
final TextEditingController dobController = TextEditingController();
final TextEditingController weightController = TextEditingController();
final TextEditingController heightController = TextEditingController();

class _CompleteProfileViewState extends State<CompleteProfileView> {
  TextEditingController txtDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/img/complete_profile.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "It will help us to know more about you!",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: TColor.lightGray,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  
                                  child: Image.asset(
                                    "assets/img/gender.png",
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.contain,
                                    color: TColor.gray,
                                  )),
                            
                              Expanded(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedGender, // Set the current value
          items: ["Male", "Female"]
              .map((name) => DropdownMenuItem<String>(
                    value: name,
                    child: Text(
                      name,
                      style: TextStyle(
                          color: TColor.gray, fontSize: 14),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedGender = value; // Update the selectedGender value
            });
          },
          isExpanded: true,
          hint: Text(
            "Choose Gender",
            style: TextStyle(color: TColor.gray, fontSize: 12),
          ),
        ),
      ),
    ),

                             const SizedBox(width: 8,)

                            ],
                          ),),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            dobController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: RoundTextField(
                          controller: dobController,
                          hitText: "Date of Birth",
                          icon: "assets/img/date.png",
                        ),
                      ),
                    ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              controller: weightController,
                              hitText: "Your Weight",
                              icon: "assets/img/weight.png",
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "KG",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              controller: heightController,
                              hitText: "Your Height",
                              icon: "assets/img/hight.png",
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "CM",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.07,
                      ),
                      RoundButton(
                      title: "Next >",
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          try {
                            // Saving data to Firestore
                            await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
                              "uid": user.uid,
                              "email": user.email,
                              "first_name": widget.firstName,  // Using the passed first name
                              "last_name": widget.lastName,    // Using the passed last name
                              "gender": selectedGender,        // Using the selected gender
                              "dob": dobController.text.trim(), // Correct controller for dob
                              "weight": weightController.text.trim(),
                              "height": heightController.text.trim(),
                              "created_at": FieldValue.serverTimestamp(),
                            });

                            // Navigate to next screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const WhatYourGoalView()),
                            );
                          } catch (e) {
                            // Handle errors if saving to Firestore fails
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error saving profile: ${e.toString()}")),
                            );
                          }
                        }
                      },
                    ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
