class Post {
  String posterSrc, title, desc, category;
  int id, favCount;
  bool isFavourite;
  List steps;

  Post(
      {required this.id,
      required this.title,
      required this.desc,
      required this.posterSrc,
      required this.category,
      required this.isFavourite,
      required this.steps,
      this.favCount = 0});
}

List<Post> recipePosts = [
  Post(
      id: 012,
      title: "Nasi Lemak",
      desc: "Delicious!",
      category: "Malay",
      isFavourite: false,
      steps: ["a", "b", "c", "d", "e"],
      posterSrc:
          "https://content.instructables.com/F3I/9KMA/INER65N5/F3I9KMAINER65N5.jpg?auto=webp&frame=1&fit=bounds&md=14c3976bdb1380ee9ec0c53cacbae17c"),
  Post(
      id: 023,
      title: "Fried Rice",
      desc: "Super Good!",
      category: "Chinese",
      isFavourite: false,
      steps: ["a", "b", "c", "d", "e"],
      posterSrc:
          "https://content.instructables.com/FKW/PGN3/IB4A0L26/FKWPGN3IB4A0L26.jpg?auto=webp&frame=1&fit=bounds&md=9cfe7f354a89ffcba686156381780ae2"),
  Post(
      id: 034,
      title: "Ramen",
      desc: "Slurpppppp",
      category: "Japanese",
      isFavourite: false,
      steps: ["a", "b", "c", "d", "e"],
      posterSrc:
          "https://www.justonecookbook.com/wp-content/uploads/2019/05/Miso-Ramen-II.jpg"),
  Post(
      id: 045,
      title: "Roti Canai",
      desc: "Crispy",
      category: "Indian",
      isFavourite: false,
      steps: ["a", "b", "c", "d", "e"],
      posterSrc:
          "https://www.theflavorbender.com/wp-content/uploads/2021/09/Roti-Canai-6501-2.jpg"),
  Post(
      id: 056,
      title: "Tteok-Bokki",
      desc: "Spicy rice cake",
      category: "Korean",
      isFavourite: false,
      steps: ["a", "b", "c", "d", "e"],
      posterSrc:
          "https://c.ndtvimg.com/2022-05/7efvlvl_korean-rice-cakes_625x300_13_May_22.jpg"),
  Post(
      id: 067,
      title: "Pesto Pasta",
      desc: "Healthy delicious pasta",
      category: "Western",
      isFavourite: false,
      steps: ["a", "b", "c", "d", "e"],
      posterSrc:
          "https://www.cookingclassy.com/wp-content/uploads/2022/02/pesto-pasta-1.jpg"),
  Post(
      id: 078,
      title: "Mango Sticky Rice",
      desc: "Tasty Thai dessert",
      category: "Thai",
      isFavourite: false,
      steps: ["a", "b", "c", "d", "e"],
      posterSrc:
          "https://food.fnr.sndimg.com/content/dam/images/food/fullset/2021/05/10/0/ASIAN_FOOD_CHANNEL_MANGO_STICKY_RICE_H_f_s4x3.jpg"),
  Post(
      id: 089,
      title: "Smoked Beef Bagels",
      desc: "Crispy buns with smoked beef",
      category: "Fast Food",
      isFavourite: false,
      steps: ["a", "b", "c", "d", "e"],
      posterSrc:
          "https://img.jamieoliver.com/jamieoliver/recipe-database/134037717.jpg"),
  Post(
      id: 090,
      title: "Chicken Rendang",
      desc: "Spicy coconut milk curry stewed chicken",
      category: "Malay",
      isFavourite: false,
      steps: ["a", "b", "c", "d", "e"],
      posterSrc:
          "https://www.ajinomoto.com.my/sites/default/files/content/recipe/image/2022-04/Simple-chicken-rendang-1.jpg"),
  Post(
      id: 101,
      title: "Fried Mee Hoon",
      desc: "Dry mee hoon fried with eggs and prawns",
      category: "Chinese",
      isFavourite: false,
      steps: ["a", "b", "c", "d", "e"],
      posterSrc:
          "https://1.bp.blogspot.com/-2xO7ykEC8Qg/Wsz2Rk_2FrI/AAAAAAAADmw/2UOA7nGEtH4fWupzMVQiwHrU7LCEBHkGgCLcBGAs/s1600/P4082121_Fotor.jpg"),
];
