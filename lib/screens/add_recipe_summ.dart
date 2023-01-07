// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookit_mobile/models/category_model.dart';
import 'package:cookit_mobile/utils/pexels_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recase/recase.dart';

import '../utils/open_ai.dart';
import '../utils/config.dart';

class AddRecipeSumm extends StatefulWidget {
  AddRecipeSumm({super.key});

  @override
  State<AddRecipeSumm> createState() => _AddRecipeSummState();
}

class _AddRecipeSummState extends State<AddRecipeSumm> {
  var controller = Get.find<RecipeSummary>();

  Future<void> deleteFiles(String stepImgURL) async {
    await Config.cloudInstance.refFromURL(stepImgURL).delete();
  }

  Future<void> _pickedImage() async {
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [Text('Choose an image source')],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  child: const Text('Camera'),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  child: const Text('Gallery'),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            )
          ]),
    ).then((source) async {
      if (source != null) {
        final pickedFile = await ImagePicker().pickImage(source: source);
        setState(() => controller.selectedImage = File(pickedFile!.path));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(10),
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Let\'s start from basic',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Name your recipe', style: TextStyle(fontSize: 16)),
              const SizedBox(
                height: 10,
              ),
              CupertinoTextField(
                controller: controller.titleController,
                placeholder: 'Pasta Carbonara',
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Serving Size', style: TextStyle(fontSize: 16)),
              const SizedBox(
                height: 10,
              ),
              CupertinoTextField(
                controller: controller.servController,
                placeholder: '1',
                maxLength: 2,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Description', style: TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: CupertinoTextField(
                      controller: controller.descController,
                      placeholder:
                          'Introduce your recipe, add cooking tips, additional notes, etc...',
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    flex: 1,
                    child: ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        icon: controller.autoText
                            ? Container(
                                width: 24,
                                height: 24,
                                padding: const EdgeInsets.all(2.0),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Icon(Icons.edit_attributes_outlined),
                        onPressed: () async {
                          if (controller.titleController.text.trim() != '') {
                            setState(() {
                              controller.autoText = true;
                            });
                            OpenAI()
                                .generateResult(
                                    'Describe ${controller.titleController.text.titleCase}')
                                .then((value) {
                              setState(() {
                                controller.autoText = false;
                              });
                              controller.descController.text = value;
                            }).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'An Error Has Occurred!\nCheck Internet Connection!'),
                                  backgroundColor: Theme.of(context).errorColor,
                                ),
                              );
                              setState(() {
                                controller.autoText = false;
                              });
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Please Enter a Title For Recipe!'),
                                backgroundColor: Theme.of(context).errorColor,
                              ),
                            );
                          }
                        },
                        label: Text(
                          "Auto-Fill",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Difficulty Level', style: TextStyle(fontSize: 16)),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: CupertinoSegmentedControl<String>(
                  children: {
                    'Easy': Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text('Easy')),
                    'Medium': Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text('Medium')),
                    'Complex': Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text('Complex')),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      controller.recipeDifficulty = value;
                    });
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  unselectedColor: CupertinoColors.white,
                  borderColor: CupertinoColors.inactiveGray,
                  pressedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  groupValue: controller.recipeDifficulty,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Cuisine Type',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoTextField(
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      actions: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: CupertinoPicker(
                              itemExtent: 35,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  controller.catController.text =
                                      categoriesList[index].title;
                                });
                              },
                              children: categoriesList
                                  .map((e) => Container(
                                        alignment: Alignment.center,
                                        child: Text(e.title),
                                      ))
                                  .toList()),
                        )
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: Text('Close'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ).then((_) {
                    if (controller.catController.text == '')
                      controller.catController.text = 'Malay';
                    FocusManager.instance.primaryFocus?.unfocus();
                  });
                },
                controller: controller.catController,
                readOnly: true,
                placeholder: 'Others',
                suffix: const Icon(Icons.navigate_next),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Preparation Time',
                style: TextStyle(fontSize: 16),
              ),
              CupertinoButton(
                child: Text(
                  '${controller.prepMinute} minute(s)',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () => showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CupertinoActionSheet(
                        actions: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: CupertinoTimerPicker(
                                initialTimerDuration:
                                    Duration(minutes: controller.prepMinute),
                                mode: CupertinoTimerPickerMode.hm,
                                onTimerDurationChanged: (value) => setState(() {
                                  controller.prepMinute = value.inMinutes;
                                }),
                              ))
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text('Close'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    flex: 3,
                    child: Text(
                      'Add a recipe photo',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: controller.autoImageLoader
                                  ? CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                      strokeWidth: 3,
                                    )
                                  : null,
                            ),
                            CupertinoSwitch(
                              value: controller.autoImage,
                              onChanged: (switching) async {
                                if (controller.titleController.text.trim() !=
                                        '' &&
                                    !controller.autoImage) {
                                  setState(() {
                                    controller.autoImageLoader = true;
                                  });
                                  if (controller.autoImageURL.length > 1) {
                                    await Config.cloudInstance
                                        .refFromURL(controller.autoImageURL)
                                        .delete();
                                  }
                                  PexelsEngine()
                                      .generateImageURL(controller
                                          .titleController.text.titleCase)
                                      .then((value) {
                                    setState(() {
                                      controller.autoImage = switching;
                                      controller.autoImageURL = value!;
                                      controller.autoImageLoader = false;
                                    });
                                  }).onError((error, stackTrace) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: const Text(
                                          'An Error Has Occurred!\nCheck Internet Connection!'),
                                      backgroundColor:
                                          Theme.of(context).errorColor,
                                    ));
                                    setState(() {
                                      controller.autoImage = false;
                                      controller.autoImageLoader = false;
                                    });
                                  });
                                } else if (controller.autoImage) {
                                  setState(() {
                                    controller.autoImage = switching;
                                    controller.autoImageURL = '';
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'Please Enter a Title For Recipe!'),
                                      backgroundColor:
                                          Theme.of(context).errorColor,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const Text(
                          'Auto Image?',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.longestSide * 0.25,
                child: InkWell(
                  onTap: () async {
                    if (controller.selectedImage != null) {
                      if (controller.autoImageURL == '') {
                        showDialog(
                            context: context,
                            builder: (_) => Dialog(
                                  child: Image.file(controller.selectedImage!),
                                ));
                      } else {
                        await _pickedImage();
                      }
                    } else if (controller.autoImageURL != '') {
                      if (controller.selectedImage == null) {
                        showDialog(
                            context: context,
                            builder: (_) => Dialog(
                                  child: CachedNetworkImage(
                                    imageUrl: controller.autoImageURL,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ));
                      } else {
                        await _pickedImage();
                      }
                    } else {
                      await _pickedImage();
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        constraints: const BoxConstraints.expand(),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: controller.selectedImage == null
                              ? controller.autoImageURL == ''
                                  ? const Align(
                                      alignment: Alignment.center,
                                      child: Text('Add Image for Recipe'))
                                  : CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: controller.autoImageURL,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )
                              : Image.file(controller.selectedImage!,
                                  fit: BoxFit.cover),
                        ),
                      ),
                      Visibility(
                        visible: (controller.autoImageURL != '' ||
                            controller.selectedImage != null),
                        replacement: const SizedBox(),
                        child: Positioned(
                          top: 15,
                          right: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white70),
                            child: IconButton(
                                highlightColor: Colors.transparent,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () async {
                                  if (controller.autoImageURL
                                      .contains('firebasestorage')) {
                                    await deleteFiles(controller.autoImageURL);
                                  }
                                  setState(() {
                                    controller.autoImageURL = '';
                                    controller.selectedImage = null;
                                    controller.autoImage = false;
                                  });
                                },
                                icon: const Icon(Icons.close)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeSummary extends GetxController {
  var recipeDifficulty = 'Easy';
  var prepMinute = 0;
  var autoText = false;
  var autoImage = false;
  var autoImageLoader = false;
  File? selectedImage;
  String autoImageURL = '';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController servController = TextEditingController();
  final TextEditingController catController = TextEditingController();
}
