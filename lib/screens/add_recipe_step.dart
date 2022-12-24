import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddRecipeStep extends StatefulWidget {
  static final GlobalKey<_AddRecipeStepState> globalKey = GlobalKey();
  const AddRecipeStep({super.key});

  @override
  State<AddRecipeStep> createState() => _AddRecipeStepState();
}

class _AddRecipeStepState extends State<AddRecipeStep> {
  var _cards = Get.put(MyCardList());
  @mustCallSuper
  @protected
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Scrollbar(
                child: Obx(
                  () => ListView.builder(
                    itemCount: _cards.cards.length,
                    itemBuilder: (context, index) => _cards.cards[index],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => _cards.addCard(),
            child: Container(
              padding: const EdgeInsets.all(2),
              height: 60,
              width: MediaQuery.of(context).size.width,
              color: Colors.teal[100],
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
    );
  }
}

//===================================Card=======================================

class MyCard extends StatelessWidget {
  final int counter;

  const MyCard({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    var _controller = Get.find<MyCardList>();
    var _index = _controller.cards.indexOf(this);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Step #' + (_index + 1).toString(),
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                IconButton(
                    onPressed: () => _controller.delCard(_index),
                    icon: Icon(Icons.delete_outline,
                        color: Theme.of(context).primaryColor)),
              ],
            ),
            CupertinoTextField(
              controller: _controller.texts[_index],
              placeholder: "Enter Steps Instructions...",
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 4,
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      'Counter: $counter',
                      style: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(100, 45),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//=================================Card-List====================================

class MyCardList extends GetxController {
  var texts = <TextEditingController>[].obs;
  var cards = <MyCard>[].obs;
  var counter = 0;
  /* ---------------------------------------------------------------------------- */
  MyCardList();
  /* ---------------------------------------------------------------------------- */
  void addCard() {
    cards.add(MyCard(counter: ++counter));
    texts.add(TextEditingController());
  }

  void delCard(int index) {
    cards.removeAt(index);
    texts.removeAt(index);
  }
}
