import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/view/water_reminder/AppColors.dart';
import 'package:fitness/view/water_reminder/delete_reminder.dart';
import 'package:fitness/view/water_reminder/notification_service.dart';
import 'package:fitness/view/water_reminder/add_reminder.dart';
import 'package:fitness/view/water_reminder/switcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';



class WaterReminder extends StatefulWidget {
  const WaterReminder({super.key});

  @override
  _WaterReminderState createState() => _WaterReminderState();
}

class _WaterReminderState extends State<WaterReminder> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      NotificationService.init(context, user!.uid);
      listenNotifications();
    }
  }

  void listenNotifications() {
    NotificationService.onNoticifation.listen((String? payload) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WaterReminder(),
        ),
      );
    });
  }

  void scheduleNotifications(QuerySnapshot data) {
for (var doc in data.docs) {
  bool isOn = doc.data().toString().contains('onoff')
      ? doc.get('onoff')
      : false;
  final docData = doc.data() as Map<String, dynamic>;
  final Timestamp t = docData['time'] ?? Timestamp.now();

  DateTime date = t.toDate();

  if (isOn) {
    NotificationService.showNotification(
      dateTime: date,
      id: doc.hashCode, // Use a unique id per reminder
      title: "Water Reminder",
      body: "Time to drink water",
    );
  }
}
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          backgroundColor: AppColors.WhiteColor,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            "Water Reminder",
            style: TextStyle(
              color: AppColors.BlackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () async {
            if (user != null) {
              addReminder(context, user!.uid);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.primaryG,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        body: user == null
            ? const Center(child: Text("User not found"))
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .collection("WaterReminder")
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4FA8C5)),
                      ),
                    );
                  }

                   if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No reminders found"),
                    );
                  }

                  final data = snapshot.data!;
                  scheduleNotifications(data);

                 
                  return ListView.builder(
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      Timestamp t = data.docs[index].get('time');
                      DateTime date = t.toDate();
                      String formattedTime = DateFormat.jm().format(date);
                      bool isOn = data.docs[index].get('onoff');

                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                            formattedTime,
                            style: const TextStyle(fontSize: 30),
                          ),
                          subtitle: const Text("Everyday"),
                          trailing: SizedBox(
                            width: 110,
                            child: Row(
                              children: [
                                Switcher(
                                  uid: user!.uid,
                                  id: data.docs[index].id,
                                  onOff: isOn,
                                  timestamp: t,
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteReminder(context, data.docs[index].id, user!.uid);
                                  },
                                  icon: const FaIcon(FontAwesomeIcons.circleXmark),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
