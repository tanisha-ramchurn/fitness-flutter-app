import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/view/water_reminder/waterReminder_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fitness/view/water_reminder/AppColors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Future<void> addReminder(BuildContext context, String uid) async {
  TimeOfDay selectedTime = TimeOfDay.now();

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: const Text("Add Reminder"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  const Text("Select time"),
                  const SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (newTime != null) {
                        setState(() {
                          selectedTime = newTime;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.clock,
                          color: AppColors.primaryColor1,
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          selectedTime.format(context),
                          style: const TextStyle(
                            fontSize: 30,
                            color: AppColors.primaryColor1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    DateTime now = DateTime.now();
                    DateTime combinedDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    WaterReminderModel waterReminderModel = WaterReminderModel(
                      timeStamp: Timestamp.fromDate(combinedDateTime),
                      onOff: false,
                    );

                    await FirebaseFirestore.instance
                        .collection('users') // <-- Match your StreamBuilder
                        .doc(uid)
                        .collection('WaterReminder')
                        .add(waterReminderModel.toMap());

                    Fluttertoast.showToast(msg: "Reminder added successfully");
                  } catch (e) {
                    Fluttertoast.showToast(msg: "Error adding reminder: $e");
                    print("Error: $e");
                  }

                  Navigator.pop(context);
                },
                child: const Text("Add"),
              ),
            ],
          );
        },
      );
    },
  );
}
