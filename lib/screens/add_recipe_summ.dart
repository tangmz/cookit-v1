import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/open_ai.dart';

class AddRecipeSumm extends StatefulWidget {
  const AddRecipeSumm({super.key});

  @override
  State<AddRecipeSumm> createState() => _AddRecipeSummState();
}

class _AddRecipeSummState extends State<AddRecipeSumm> {
  var _recipeDifficulty = "Easy";
  var _prepMinute = 0;
  var _autoSelect = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Let\'s start from basic',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Text('Name your recipe', style: TextStyle(fontSize: 16)),
          SizedBox(
            height: 10,
          ),
          CupertinoTextField(
            controller: _titleController,
            placeholder: 'Pasta Carbonara',
          ),
          SizedBox(
            height: 20,
          ),
          Text('Serving Size', style: TextStyle(fontSize: 16)),
          SizedBox(
            height: 10,
          ),
          CupertinoTextField(
            placeholder: '1',
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 20,
          ),
          Text('Description', style: TextStyle(fontSize: 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: CupertinoTextField(
                  controller: _descController,
                  placeholder: 'Recipe Description',
                  minLines: 1,
                  maxLines: 4,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                flex: 1,
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor)),
                    icon: _autoSelect
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
                    onPressed: () {
                      if (_descController.text.trim() != '') {
                        setState(() {
                          _autoSelect = true;
                        });
                        OpenAI()
                            .generateResult('Describe ${_titleController.text}')
                            .then((value) {
                          setState(() {
                            _autoSelect = false;
                          });
                          _descController.text = value;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please Enter a Title For Recipe!'),
                            backgroundColor: Theme.of(context).errorColor,
                          ),
                        );
                      }
                    },
                    label: Text("Auto-Fill")),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text('Difficulty Level', style: TextStyle(fontSize: 16)),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: CupertinoSegmentedControl<String>(
              children: {
                'Easy':
                    Container(padding: EdgeInsets.all(10), child: Text("Easy")),
                'Medium': Container(
                    padding: EdgeInsets.all(10), child: Text("Medium")),
                'Complex': Container(
                    padding: EdgeInsets.all(10), child: Text("Complex")),
              },
              onValueChanged: (value) {
                setState(() {
                  _recipeDifficulty = value;
                });
              },
              selectedColor: Theme.of(context).primaryColor,
              unselectedColor: CupertinoColors.white,
              borderColor: CupertinoColors.inactiveGray,
              pressedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              groupValue: _recipeDifficulty,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Preparation Time",
            style: TextStyle(fontSize: 16),
          ),
          CupertinoButton(
              child: Text('$_prepMinute minute(s)'),
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.38,
                        child: Column(
                          children: [
                            CupertinoTimerPicker(
                              initialTimerDuration:
                                  Duration(minutes: _prepMinute),
                              mode: CupertinoTimerPickerMode.hm,
                              onTimerDurationChanged: (value) => setState(() {
                                _prepMinute = value.inMinutes;
                              }),
                            ),
                            CupertinoButton.filled(
                                child: Text("Close"),
                                onPressed: () => Navigator.pop(context))
                          ],
                        ));
                  })),
          SizedBox(
            height: 20,
          ),
          Text(
            "Add a recipe photo",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
