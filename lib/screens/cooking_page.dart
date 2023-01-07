// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:simple_tags/simple_tags.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/posts_model.dart';
import '../utils/config.dart';
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
  final FlutterTts _textToSpeech = FlutterTts();

  @override
  void initState() {
    super.initState();
    listenSensor();
    ttsConfig();
  }

  @override
  void dispose() {
    _textToSpeech.stop();
    _streamSubscription.cancel();
    super.dispose();
  }

  ////////////////////////TexToSpeech///////////////////////
  Future<void> ttsConfig() async {
    await _textToSpeech.setLanguage('en-AU');
    await _textToSpeech.setSpeechRate(0.5);
    await _textToSpeech.setVolume(0.6);
    await _textToSpeech.setVoice({"name": "Karen", "locale": "en-AU"});
    Future.delayed(Duration(milliseconds: 500)).then((value) =>
        _textToSpeech.speak(widget.selectedPost.steps!.first.stepDesc!));
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
        _pageIndex < widget.selectedPost.steps!.length - 1
            ? _pageIndex += event
            : _pageIndex = _pageIndex;
      });
      _pageController.animateToPage(_pageIndex,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingDraggableWidget(
      mainScreenWidget: Scaffold(
        body: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).viewPadding.top + 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmoothPageIndicator(
                controller: _pageController,
                count: widget.selectedPost.steps!.length,
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
          CookingStepControlButtons(
              pageIndex: _pageIndex,
              pageController: _pageController,
              widget: widget)
        ]),
      ),
      floatingWidget: FloatingActionButton(
        foregroundColor: Theme.of(context).canvasColor,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => TimerWatch(),
          );
        },
        tooltip: 'Timer',
        child: const Icon(Ionicons.ios_timer_outline),
      ),
      autoAlign: true,
      speed: 1,
      floatingWidgetHeight: 50,
      floatingWidgetWidth: 50,
      screenHeight: MediaQuery.of(context).size.height - 25,
      dy: MediaQuery.of(context).size.height * 0.45,
      dx: MediaQuery.of(context).size.width * 0.86,
    );
  }

  Expanded cooking_step_body() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.selectedPost.steps!.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
            child: ScrollConfiguration(
              behavior: ScrollGlowBehaviour(),
              child: ListView(
                children: [
                  Text(
                    ('\t${index + 1}'),
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  widget.selectedPost.steps![index].stepImgSrc != ''
                      ? Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.longestSide *
                                  0.02),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Center(
                                child: Center(
                              child: CachedNetworkImage(
                                imageUrl: widget
                                    .selectedPost.steps![index].stepImgSrc!,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            )),
                          ))
                      : SizedBox.shrink(),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.shortestSide * 0.03),
                    child: SimpleTags(
                        tagTextOverflow: TextOverflow.fade,
                        wrapSpacing: 10,
                        tagContainerMargin: EdgeInsets.only(top: 10),
                        tagContainerPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        tagContainerDecoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        content: widget.selectedPost.steps![index].indg!),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical:
                            MediaQuery.of(context).size.longestSide * 0.03,
                        horizontal:
                            MediaQuery.of(context).size.shortestSide * 0.05),
                    child: Text(
                      widget.selectedPost.steps![index].stepDesc!,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onPageChanged: (value) async {
          setState(() {
            _pageIndex = value;
          });
          await _textToSpeech
              .speak(widget.selectedPost.steps![value].stepDesc!);
        },
        scrollBehavior: ScrollGlowBehaviour(),
      ),
    );
  }
}
