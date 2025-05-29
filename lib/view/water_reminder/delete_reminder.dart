import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

Future<void> deleteReminder(BuildContext context, String id, String uid) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: const Text("Delete Reminder"),
        content: const Text("Are you sure you want to delete this reminder?"),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .collection("WaterReminder") // Change to "water_reminder" if needed
                    .doc(id)
                    .delete();

                Fluttertoast.showToast(msg: "Reminder deleted");
              } catch (e) {
                Fluttertoast.showToast(msg: "Error deleting reminder");
              }
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}

