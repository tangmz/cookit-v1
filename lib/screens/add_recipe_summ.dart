import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddRecipeSumm extends StatefulWidget {
  const AddRecipeSumm({super.key});

  @override
  State<AddRecipeSumm> createState() => _AddRecipeSummState();
}

class _AddRecipeSummState extends State<AddRecipeSumm> {
  String recipeDifficulty = "Easy";
  int prepMinute = 0;

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
            "Let's start from basic",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 30,
          ),
          Text("Name your recipe", style: TextStyle(fontSize: 16)),
          SizedBox(
            height: 10,
          ),
          CupertinoTextField(
            placeholder: "Pasta Carbonara",
          ),
          SizedBox(
            height: 30,
          ),
          Text("Serving Size", style: TextStyle(fontSize: 16)),
          SizedBox(
            height: 10,
          ),
          CupertinoTextField(
            placeholder: "1",
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 30,
          ),
          Text("Difficulty Level", style: TextStyle(fontSize: 16)),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: CupertinoSegmentedControl<String>(
              children: {
                "Easy":
                    Container(padding: EdgeInsets.all(10), child: Text("Easy")),
                "Medium": Container(
                    padding: EdgeInsets.all(10), child: Text("Medium")),
                "Complex": Container(
                    padding: EdgeInsets.all(10), child: Text("Complex")),
              },
              onValueChanged: (value) {
                setState(() {
                  recipeDifficulty = value;
                });
              },
              selectedColor: Theme.of(context).primaryColor,
              unselectedColor: CupertinoColors.white,
              borderColor: CupertinoColors.inactiveGray,
              pressedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              groupValue: recipeDifficulty,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Preparation Time",
            style: TextStyle(fontSize: 16),
          ),
          CupertinoButton(
              child: Text('$prepMinute minute(s)'),
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.38,
                        child: Column(
                          children: [
                            CupertinoTimerPicker(
                              initialTimerDuration:
                                  Duration(minutes: prepMinute),
                              mode: CupertinoTimerPickerMode.hm,
                              onTimerDurationChanged: (value) => setState(() {
                                prepMinute = value.inMinutes;
                              }),
                            ),
                            CupertinoButton.filled(
                                child: Text("Close"),
                                onPressed: () => Navigator.pop(context))
                          ],
                        ));
                  })),
          SizedBox(
            height: 30,
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
