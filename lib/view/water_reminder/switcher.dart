import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/view/water_reminder/waterReminder_model.dart';
import 'package:flutter/material.dart';

class Switcher extends StatefulWidget {
  final String uid;
  final String id;
  final bool onOff;
  final Timestamp timestamp;

  const Switcher({
    Key? key,
    required this.uid,
    required this.id,
    required this.onOff,
    required this.timestamp,
  }) : super(key: key);

  @override
  State<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.onOff,
      onChanged: (bool value) async {
        WaterReminderModel waterReminderModel = WaterReminderModel();
        waterReminderModel.onOff = value;
        waterReminderModel.timeStamp = widget.timestamp;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .collection('WaterReminder')
            .doc(widget.id)
            .update(waterReminderModel.toMap());
        setState(() {});
      },
    );
  }
}
