import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:fitness/view/water_reminder/water_reminder_view.dart';
import 'package:rxdart/rxdart.dart';


class NotificationService {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNoticifation = BehaviorSubject<String?>();

 static Future _notificationDetails() async{
  return const NotificationDetails(
    android: AndroidNotificationDetails(
      "Hydration time!!","Don't forget to drink water",
      importance: Importance.max, 
      priority: Priority.max
    ),
  );
 } 

  static Future init (BuildContext context, String uid )async{
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings("time_workout.png");
    final settings =InitializationSettings(android: android);
    await _notification.initialize(settings,
    onDidReceiveBackgroundNotificationResponse: (payload){
      Navigator.pushReplacement(context, 
      MaterialPageRoute(
        builder: 
        (context) =>  const WaterReminder(),
        ));

      onNoticifation.add(payload as String?);
    }
    );
  }
      static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime dateTime, 
    }) async {
      if(dateTime.isBefore(DateTime.now())){
        dateTime = dateTime.add(const Duration(days: 1));
      }

      _notification.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(dateTime, tz.local),
        await _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
}