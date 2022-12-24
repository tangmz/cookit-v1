import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:proximity_sensor/proximity_sensor.dart';

import '../models/posts_model.dart';

class CookingPage extends StatefulWidget {
  final Post selectedPost;
  const CookingPage({required this.selectedPost, super.key});

  @override
  State<CookingPage> createState() => _CookingPageState();
}

class _CookingPageState extends State<CookingPage> {
  final _pageController = PageController(
    keepPage: true,
  );
  int _pageIndex = 0;
  late StreamSubscription<dynamic> _streamSubscription;

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

  ////////////////////////Proximity Sensor//////////////////
  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _pageIndex < widget.selectedPost.steps.length - 1
            ? _pageIndex += event
            : _pageIndex = _pageIndex;
      });
      _pageController.animateToPage(_pageIndex,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmoothPageIndicator(
                controller: _pageController,
                count: widget.selectedPost.steps.length,
                effect: SwapEffect(
                    dotColor: (Colors.grey[500])!,
                    activeDotColor: Theme.of(context).primaryColor,
                    dotHeight: 8,
                    dotWidth: 20,
                    spacing: 5),
              ),
            ],
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.selectedPost.steps.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (index + 1).toString(),
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      Image.network(widget.selectedPost.posterSrc),
                      Text(
                        widget.selectedPost.steps[index],
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                );
              },
              onPageChanged: (value) {
                setState(() {
                  _pageIndex = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                  onPressed: _pageIndex == 0
                      ? null
                      : () => _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn),
                  icon: Icon(Icons.arrow_back_ios_new),
                  label: Text("Previous"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      fixedSize: Size(150, 40))),
              ElevatedButton.icon(
                  onPressed: _pageIndex == widget.selectedPost.steps.length - 1
                      ? () => Navigator.pop(context)
                      : () => _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn),
                  icon: _pageIndex == widget.selectedPost.steps.length - 1
                      ? Icon(Icons.check)
                      : Icon(Icons.arrow_forward_ios),
                  label: _pageIndex == widget.selectedPost.steps.length - 1
                      ? Text("Done")
                      : Text("Next"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _pageIndex == widget.selectedPost.steps.length - 1
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                      fixedSize: Size(150, 40))),
            ],
          )
        ]),
      ),
    );
  }
}
