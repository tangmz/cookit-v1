// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookit_mobile/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddRecipeStep extends StatefulWidget {
  MyCardList cardList;
  AddRecipeStep({required this.cardList, super.key});

  @override
  State<AddRecipeStep> createState() => _AddRecipeStepState();
}

class _AddRecipeStepState extends State<AddRecipeStep> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Scrollbar(
                    child: Obx(
                      () => ListView.builder(
                        itemCount: widget.cardList.cards.length,
                        itemBuilder: (context, index) =>
                            widget.cardList.cards[index],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => widget.cardList.addCard(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColor,
                  ),
                  padding: const EdgeInsets.all(2),
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(width: 10),
                        Icon(Icons.add, color: Colors.red),
                        SizedBox(width: 10),
                        Text('Add Cooking Step'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//===================================Card=======================================

class MyCard extends StatelessWidget {
  const MyCard({super.key});

  Future<void> deleteFiles(String stepImgURL) async {
    await Config.cloudInstance.refFromURL(stepImgURL).delete();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<MyCardList>();
    var index = controller.cards.indexOf(this);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Step #${index + 1}',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                IconButton(
                    onPressed: () => controller.delCard(index),
                    icon: Icon(Icons.delete_outline,
                        color: Theme.of(context).primaryColor)),
              ],
            ),
            CupertinoTextField(
              controller: controller.steps[index],
              placeholder: "Enter Steps Instructions...",
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 3,
            ),
            SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              controller: controller.indg[index],
              placeholder: "Enter the Ingredients Needed...",
              suffix: Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: 'e.g. apple,banana,cinammon',
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(Icons.help_outline,
                        color: Theme.of(context).hintColor),
                  )),
            ),
            const Divider(),
            Obx(
              () => Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.longestSide * 0.23,
                    width: MediaQuery.of(context).size.shortestSide * 0.6,
                    child: InkWell(
                        onTap: () async {
                          controller.imageFiles[index] == null
                              ? controller.imageURL[index] != ''
                                  ? showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        child: CachedNetworkImage(
                                          imageUrl: controller.imageURL[index]!,
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    )
                                  : pickImagePopUp(context)
                                      .then((source) async {
                                      if (source != null) {
                                        final pickedFile = await ImagePicker()
                                            .pickImage(source: source);
                                        controller.imageFiles[index] =
                                            File(pickedFile!.path);
                                      }
                                    })
                              : showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                      child: Image.file(
                                          controller.imageFiles[index]!)),
                                );
                        },
                        child: Container(
                            decoration: ShapeDecoration(
                              color: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: controller.imageFiles[index] == null
                                  ? controller.imageURL[index] != ''
                                      ? CachedNetworkImage(
                                          fit: BoxFit.fitHeight,
                                          imageUrl: controller.imageURL[index]!,
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )
                                      : Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              'Add Image for Step #${index + 1}'))
                                  : Image.file(controller.imageFiles[index]!,
                                      fit: BoxFit.cover),
                            ))),
                  ),
                  Visibility(
                    visible: (controller.imageFiles[index] != null ||
                        controller.imageURL[index] != ''),
                    replacement: const SizedBox(),
                    child: Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white70),
                        child: IconButton(
                            highlightColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () async {
                              if (controller.imageURL[index] != '') {
                                await deleteFiles(controller.imageURL[index]!);
                              }
                              controller.imageFiles[index] = null;
                              controller.imageURL[index] = '';
                            },
                            icon: const Icon(Icons.close)),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> pickImagePopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [Text('Choose an image source')],
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
            child: const Text("Camera"),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
            child: const Text("Gallery"),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

//=================================Card-List====================================

class MyCardList extends GetxController {
  var steps = <TextEditingController>[];
  var indg = <TextEditingController>[];
  var cards = <MyCard>[].obs;
  var imageFiles = <File?>[].obs;
  var imageURL = <String?>[];
  /* ---------------------------------------------------------------------------- */
  MyCardList();
  /* ---------------------------------------------------------------------------- */
  void addCard() {
    cards.add(MyCard());
    steps.add(TextEditingController());
    indg.add(TextEditingController());
    imageFiles.add(null);
    imageURL.add('');
  }

  void delCard(int index) {
    cards.removeAt(index);
    steps[index].dispose();
    indg[index].dispose();
    steps.removeAt(index);
    indg.removeAt(index);
    imageFiles.removeAt(index);
    imageURL.removeAt(index);
  }
}
