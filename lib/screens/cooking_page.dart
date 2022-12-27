import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';

import '../models/posts_model.dart';
import '../widgets/cooking_control_buttons.dart';
import '../widgets/timer.dart';

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
      child: FloatingDraggableWidget(
        mainScreenWidget: Scaffold(
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
                  effect: ScrollingDotsEffect(
                      dotColor: (Colors.grey[500])!,
                      activeDotColor: Theme.of(context).primaryColor,
                      dotHeight: 8,
                      dotWidth: 20,
                      spacing: 5),
                ),
              ],
            ),

            //Body of the cooking steps page
            cooking_step_body(),

            //control buttons
            cooking_step_control_buttons(
                pageIndex: _pageIndex,
                pageController: _pageController,
                widget: widget)
          ]),
        ),
        floatingWidget: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => TimerWatch(),
            );
          },
          tooltip: 'Timer',
          child: const Icon(Icons.timer_outlined),
        ),
        autoAlign: true,
        speed: 1,
        floatingWidgetHeight: 50,
        floatingWidgetWidth: 50,
        screenHeight: MediaQuery.of(context).size.height - 25,
      ),
    );
  }

  Expanded cooking_step_body() {
    return Expanded(
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
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Center(
                        child: Image.network(widget.selectedPost.posterSrc))),
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
    );
  }
}
