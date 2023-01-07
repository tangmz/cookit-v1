// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:cloud_firestore/cloud_firestore.dart';

import 'steps_model.dart';
import 'reviews_model.dart';

class Post {
  String? postID, userID, posterSrc, title, desc, category, difficulty;
  int? favCount, servSize, prepTime;
  double? postRatings;
  List<Steps>? steps;
  List<Reviews>? reviews;

  Post({
    this.postID,
    required this.userID,
    required this.posterSrc,
    required this.title,
    required this.desc,
    category = 'Others',
    required this.difficulty,
    favCount = 0,
    servSize,
    required this.prepTime,
    required this.steps,
    postRatings = 0.0,
    reviews,
  })  : category = category ?? 'Others',
        favCount = favCount ?? 0,
        servSize = servSize ?? 1,
        postRatings = postRatings ?? 0.0,
        reviews = reviews ?? [];

  factory Post.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Post(
      postID: data?['postID'],
      userID: data?['userID'],
      posterSrc: data?['posterSrc'],
      title: data?['title'],
      desc: data?['desc'],
      category: data?['category'],
      difficulty: data?['difficulty'],
      favCount: data?['favCount'],
      servSize: data?['servSize'],
      prepTime: data?['prepTime'],
      postRatings: data?['postRatings'],
      steps: data?['steps'] is Iterable
          ? List.from((data?['steps'] as List)
              .map((data) => Steps(
                    stepDesc: data?['stepDesc'],
                    stepImgSrc: data?['stepImgSrc'],
                    indg: (data?['indg'] as List)
                        .map((e) => e.toString())
                        .toList(),
                  ))
              .toList())
          : null,
      reviews: data?['reviews'] is Iterable
          ? (data?['reviews'] as List).isNotEmpty
              ? (data?['reviews'] as List)
                  .map((data) => Reviews(
                        userName: data?['userName'],
                        userID: data?['userID'],
                        comments: data?['comments'],
                        ratings: data?['ratings'],
                      ))
                  .toList()
              : null
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "postID": postID,
      "userID": userID,
      "posterSrc": posterSrc,
      "title": title,
      "desc": desc,
      if (category != null) "category": category,
      "difficulty": difficulty,
      if (favCount != null) "favCount": favCount,
      "servSize": servSize,
      "prepTime": prepTime,
      "postRatings": postRatings,
      if (steps != null)
        "steps": steps
            ?.map((data) => {
                  "stepDesc": data.stepDesc,
                  "stepImgSrc": data.stepImgSrc,
                  "indg": data.indg,
                })
            .toList(),
      if (reviews != null)
        "reviews": reviews
            ?.map((data) => {
                  "userName": data.userName,
                  "userID": data.userID,
                  "comments": data.comments,
                  "ratings": data.ratings,
                })
            .toList(),
    };
  }
}

List<String> titleIterator = [
  'Nasi Lemak',
  'Roti Canai',
  'Pasta',
  'Fried Rice',
  'Ramen',
  'Burger'
];

List<Post> recipePosts = [
  Post(
      postID: '012',
      userID: '000',
      difficulty: 'Easy',
      servSize: 1,
      prepTime: 20,
      favCount: 0,
      title: "Nasi Lemak",
      desc: "Delicious!",
      category: "Malay",
      steps: [
        Steps(indg: ['Item1', 'Item2']),
        Steps(indg: ['', 'Item4', 'Item5'])
      ],
      postRatings: 4.5,
      reviews: [
        Reviews(userName: 'Huat', comments: 'Good lah', ratings: 5.0),
        Reviews(userName: 'Ong', comments: 'Best!', ratings: 4.0)
      ],
      posterSrc:
          "https://content.instructables.com/F3I/9KMA/INER65N5/F3I9KMAINER65N5.jpg?auto=webp&frame=1&fit=bounds&md=14c3976bdb1380ee9ec0c53cacbae17c"),
  Post(
      postID: '023',
      userID: '000',
      difficulty: 'Easy',
      servSize: 1,
      prepTime: 20,
      favCount: 0,
      title: "Fried Rice",
      desc: "Super Good!",
      category: "Chinese",
      steps: [
        Steps(indg: ['Item1', 'Item2']),
        Steps(indg: ['Item3', 'Item4', 'Item5'])
      ],
      postRatings: 4.5,
      reviews: [
        Reviews(userName: 'Huat', comments: 'Good lah', ratings: 5.0),
        Reviews(userName: 'Ong', comments: 'Best!', ratings: 4.0)
      ],
      posterSrc:
          "https://content.instructables.com/FKW/PGN3/IB4A0L26/FKWPGN3IB4A0L26.jpg?auto=webp&frame=1&fit=bounds&md=9cfe7f354a89ffcba686156381780ae2"),
  Post(
      postID: '034',
      userID: '1N9ghn3WNaPlzUd3l9sSvtCtPPB2',
      difficulty: 'Easy',
      servSize: 1,
      prepTime: 20,
      favCount: 0,
      title: "Ramen",
      desc: "Slurpppppp",
      category: "Japanese",
      steps: [
        Steps(indg: ['Item1', 'Item2'], stepDesc: 'happy'),
        Steps(indg: ['Item3', 'Item4', 'Item5'], stepDesc: 'Go Lucky')
      ],
      postRatings: 4.5,
      reviews: [
        Reviews(userName: 'Huat', comments: 'Good lah', ratings: 5.0),
        Reviews(userName: 'Ong', comments: 'Best!', ratings: 4.0)
      ],
      posterSrc:
          "https://www.justonecookbook.com/wp-content/uploads/2019/05/Miso-Ramen-II.jpg"),
  Post(
      postID: '045',
      userID: '000',
      difficulty: 'Easy',
      servSize: 1,
      prepTime: 20,
      favCount: 0,
      title: "Roti Canai",
      desc: "Crispy",
      category: "Indian",
      steps: [
        Steps(indg: ['Item1', 'Item2']),
        Steps(indg: ['Item3', 'Item4', 'Item5'])
      ],
      postRatings: 4.5,
      reviews: [
        Reviews(userName: 'Huat', comments: 'Good lah', ratings: 5.0),
        Reviews(userName: 'Ong', comments: 'Best!', ratings: 4.0)
      ],
      posterSrc:
          "https://www.theflavorbender.com/wp-content/uploads/2021/09/Roti-Canai-6501-2.jpg"),
  Post(
      postID: '056',
      userID: '000',
      difficulty: 'Easy',
      servSize: 1,
      prepTime: 20,
      favCount: 0,
      title: "Tteok-Bokki",
      desc: "Spicy rice cake",
      category: "Korean",
      steps: [
        Steps(indg: ['Item1', 'Item2']),
        Steps(indg: ['Item3', 'Item4', 'Item5'])
      ],
      postRatings: 4.5,
      reviews: [
        Reviews(userName: 'Huat', comments: 'Good lah', ratings: 5.0),
        Reviews(userName: 'Ong', comments: 'Best!', ratings: 4.0)
      ],
      posterSrc:
          "https://c.ndtvimg.com/2022-05/7efvlvl_korean-rice-cakes_625x300_13_May_22.jpg"),
  Post(
      postID: '067',
      userID: '000',
      difficulty: 'Easy',
      servSize: 1,
      prepTime: 20,
      favCount: 0,
      title: "Pesto Pasta",
      desc: "Healthy delicious pasta",
      category: "Western",
      steps: [
        Steps(indg: ['Item1', 'Item2']),
        Steps(indg: ['Item3', 'Item4', 'Item5'])
      ],
      postRatings: 4.5,
      reviews: [
        Reviews(userName: 'Huat', comments: 'Good lah', ratings: 5.0),
        Reviews(userName: 'Ong', comments: 'Best!', ratings: 4.0)
      ],
      posterSrc:
          "https://www.cookingclassy.com/wp-content/uploads/2022/02/pesto-pasta-1.jpg"),
  Post(
      postID: '078',
      userID: '000',
      difficulty: 'Easy',
      servSize: 1,
      prepTime: 20,
      favCount: 0,
      title: "Mango Sticky Rice",
      desc: "Tasty Thai dessert",
      category: "Thai",
      steps: [
        Steps(indg: ['Item1', 'Item2']),
        Steps(indg: ['Item3', 'Item4', 'Item5'])
      ],
      postRatings: 4.5,
      reviews: [
        Reviews(userName: 'Huat', comments: 'Good lah', ratings: 5.0),
        Reviews(userName: 'Ong', comments: 'Best!', ratings: 4.0)
      ],
      posterSrc:
          "https://food.fnr.sndimg.com/content/dam/images/food/fullset/2021/05/10/0/ASIAN_FOOD_CHANNEL_MANGO_STICKY_RICE_H_f_s4x3.jpg"),
  Post(
      postID: '089',
      userID: '000',
      difficulty: 'Easy',
      servSize: 1,
      prepTime: 20,
      favCount: 0,
      title: "Smoked Beef Bagels",
      desc: "Crispy buns with smoked beef",
      category: "Fast Food",
      steps: [
        Steps(indg: ['Item1', 'Item2']),
        Steps(indg: ['Item3', 'Item4', 'Item5'])
      ],
      postRatings: 4.5,
      reviews: [
        Reviews(userName: 'Huat', comments: 'Good lah', ratings: 5.0),
        Reviews(userName: 'Ong', comments: 'Best!', ratings: 4.0)
      ],
      posterSrc:
          "https://img.jamieoliver.com/jamieoliver/recipe-database/134037717.jpg"),
  Post(
      postID: '090',
      userID: '000',
      difficulty: 'Easy',
      servSize: 1,
      prepTime: 20,
      favCount: 0,
      title: "Chicken Rendang",
      desc: "Spicy coconut milk curry stewed chicken",
      category: "Malay",
      steps: [
        Steps(indg: ['Item1', 'Item2']),
        Steps(indg: ['Item3', 'Item4', 'Item5'])
      ],
      postRatings: 4.5,
      reviews: [
        Reviews(userName: 'Huat', comments: 'Good lah', ratings: 5.0),
        Reviews(userName: 'Ong', comments: 'Best!', ratings: 4.0)
      ],
      posterSrc:
          "https://www.ajinomoto.com.my/sites/default/files/content/recipe/image/2022-04/Simple-chicken-rendang-1.jpg"),
  Post(
      postID: '101',
      userID: '000',
      difficulty: 'Easy',
      servSize: 1,
      prepTime: 20,
      favCount: 0,
      title: "Fried Mee Hoon",
      desc: "Dry mee hoon fried with eggs and prawns",
      category: "Chinese",
      steps: [
        Steps(indg: ['Item1', 'Item2']),
        Steps(indg: ['Item3', 'Item4', 'Item5'])
      ],
      postRatings: 4.5,
      reviews: [
        Reviews(userName: 'Huat', comments: 'Good lah', ratings: 5.0),
        Reviews(userName: 'Ong', comments: 'Best!', ratings: 4.0)
      ],
      posterSrc:
          "https://1.bp.blogspot.com/-2xO7ykEC8Qg/Wsz2Rk_2FrI/AAAAAAAADmw/2UOA7nGEtH4fWupzMVQiwHrU7LCEBHkGgCLcBGAs/s1600/P4082121_Fotor.jpg"),
];
