import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

import '../widgets/notification.dart';

class TimerWatch extends StatefulWidget {
  const TimerWatch({super.key});

  @override
  State<TimerWatch> createState() => _TimerWatchState();
}

class _TimerWatchState extends State<TimerWatch> {
  final controller = Get.put(TimerController());
  int timerSeconds = 0;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    Noti.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
          color: (Theme.of(context).scaffoldBackgroundColor),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () => controller.time.value == '00:00:00'
                ? Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.18,
                        child: CupertinoTimerPicker(
                          mode: CupertinoTimerPickerMode.hms,
                          onTimerDurationChanged: (Duration value) =>
                              timerSeconds = value.inSeconds,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (timerSeconds > 0)
                            controller.startTimer(timerSeconds);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Start"),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.time.toString(),
                        style: TextStyle(fontSize: 50),
                      ),
                      TextButton(
                        onPressed: () => controller.onClose(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Stop"),
                          ],
                        ),
                      ),
                    ],
                  ),
          )),
    );
  }
}

class TimerController extends GetxController {
  final time = '00:00:00'.obs;
  int remainingSeconds = 0;
  Timer? timer;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
      time.value = '00:00:00';
    }

    super.onClose();
  }

  void startTimer(int seconds) {
    remainingSeconds = seconds;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds < 0) {
        Noti.showTextNotification(
            title: "Alarm",
            body: "Your Timer is Up!",
            fln: flutterLocalNotificationsPlugin);
        timer.cancel();
      } else {
        int hours = remainingSeconds ~/ 3600;
        int minutes = (remainingSeconds ~/ 60) % 60;
        int seconds = remainingSeconds %
            60; //Truncated division: divison with removal of decimals
        time.value = hours.toString().padLeft(2, "0") +
            ":" +
            minutes.toString().padLeft(2, "0") +
            ":" +
            seconds.toString().padLeft(2, "0");
        remainingSeconds--;
      }
    });
  }
}
