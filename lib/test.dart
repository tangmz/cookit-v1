import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:pexels_null_safety/pexels_null_safety.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  bool _isNear = false;
  String returnedPhoto =
      'https://cdn.pixabay.com/photo/2019/11/05/00/53/cellular-4602489_960_720.jpg';
  var _counter = 0;
  late StreamSubscription<dynamic> _streamSubscription;
  final _pexelsClient =
      PexelsClient('563492ad6f917000010000019acfce4535a444c1a0ef8652afbcbd3d');
  List images = [];
  int page = 1;

  @override
  void initState() {
    super.initState();
    listenSensor();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  ///////////////Pexels///////////////////
  searchImage(String name) async {
    // await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
    //     headers: {
    //       'Authorization':
    //           '563492ad6f917000010000019acfce4535a444c1a0ef8652afbcbd3d'
    //     }).then((value) {
    //   Map result = jsonDecode(value.body);
    //   setState(() {
    //     images = result['photos'];
    //   });
    //   print(images[0]['id']);
    // });
    var result = await _pexelsClient.searchPhotos(name);
    var photo = result![0];
    print(returnedPhoto);
    print(await _pexelsClient.getQuota());
    setState(() {
      returnedPhoto = photo!.sources['medium']!.link!;
    });
  }

////////////////////////Proximity Sensor//////////////////
  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _counter += event;
        _isNear = (event > 0) ? true : false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proximity Sensor Example'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('proximity sensor, is near ?  $_isNear\n'),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Food Name',
              ),
              onSubmitted: (value) => searchImage(value),
            ),
            Image.network(returnedPhoto),
            Text("This is the page of $_counter"),
          ],
        ),
      ),
    );
  }
}
