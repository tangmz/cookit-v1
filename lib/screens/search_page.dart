import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/post_grid.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController textController;
  List<String> filterHighlight = ["Pork-Free", "Gluten-Free", "Vegeterian"];
  List<bool> isChecked = List<bool>.generate(3, (index) => false);

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: CupertinoSearchTextField(
            controller: textController,
            backgroundColor: Theme.of(context).bottomAppBarColor),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  icon: Icon(Icons.filter_list));
            },
          )
        ],
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          children: [
            Expanded(
                child: ListView(shrinkWrap: true, children: [
              Container(
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Hightlights",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: filterHighlight.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                        title: Text(filterHighlight[index]),
                        value: isChecked[index],
                        onChanged: (value) => setState(() {
                              isChecked[index] = value!;
                            }));
                  })
            ])),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  minimumSize: MaterialStateProperty.all(Size(150, 35))),

              //=========================Enter Something Here===============================
              onPressed: () {},
              child: Text("Apply"),
            )
          ],
        ),
      ),
      body: PostGrid(),
    ));
  }
}
