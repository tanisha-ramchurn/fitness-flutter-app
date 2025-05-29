import 'package:cloud_firestore/cloud_firestore.dart';

class WaterReminderModel {
    Timestamp? timeStamp;
    bool?onOff;
     
      WaterReminderModel({this.timeStamp, this.onOff});

        Map<String, dynamic> toMap(){
          return{
            'time': timeStamp,
            'onoff': onOff,
          };
        }

        factory WaterReminderModel.fromMap(map){
          return WaterReminderModel(
            timeStamp: map['time'],
            onOff: map['onoff'],
          );
        }


}