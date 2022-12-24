import 'package:flutter/material.dart';

class Category {
  final String icon, title;

  Category({required this.icon, required this.title});
}

List<Category> demo_categories = [
  Category(
    icon:
        "https://media.istockphoto.com/id/526149521/photo/nasi-lemak-coconut-milk-rice-malaysian-cuisine.jpg?s=612x612&w=0&k=20&c=_X5WOu-uNzYmz_Sz3EWJDSZXraOzpTMXVW7e_Fdn14U=",
    title: "Malay",
  ),
  Category(
    icon:
        "https://media.istockphoto.com/id/1266408475/photo/indian-delicious-cuisine-paneer-tikka-masala-with-tandoori-chapati-on-white-background.jpg?s=612x612&w=0&k=20&c=Ry-3544N2stmPDDl-WnhucZTItuWiIpcKuy6m7PkkLU=",
    title: "Indian",
  ),
  Category(
    icon:
        "https://media.istockphoto.com/id/1069146316/photo/chinese-steamed-buns-isolated-on-white-background.jpg?s=612x612&w=0&k=20&c=-mZiRHDLV7SbTEBJKG6Rn1snOBO8WAzIGqgiyUAeRCc=",
    title: "Chinese",
  ),
  Category(
    icon:
        "https://media.istockphoto.com/id/1417414091/photo/close-up-of-korean-dish-isolate-variety-of-appetizers-with-vegetables-and-eggs-diet-bibimbap.jpg?s=612x612&w=0&k=20&c=zLn2H1kKSbzPju2n6cMw5v9S39S8OtvyAWJQqjmZyQQ=",
    title: "Korean",
  ),
  Category(
    icon:
        "https://media.istockphoto.com/id/536068996/photo/set-of-sushi-maki-and-rolls-at-box-isolated.jpg?s=612x612&w=0&k=20&c=B2pDJcXQ2VEQvPa4Tu2Ui_PetxZQ1QdWTFamIYg0otU=",
    title: "Japanese",
  ),
  Category(
    icon:
        "https://media.istockphoto.com/id/1303503607/photo/tom-yam-kung-prawn-and-lemon-soup-with-mushrooms-thai-food-in-a-white-bowl-isolated-on-white.jpg?s=612x612&w=0&k=20&c=rjUYDNVsJhOR3pK7nQJ0UhsSEILjfNHLjRfN7ssplBs=",
    title: "Thai",
  ),
  Category(
    icon:
        "https://media.istockphoto.com/id/172397221/photo/spaghetti-puttanesca.jpg?s=612x612&w=0&k=20&c=6FmVJotQON_6BgXt65SSksdNO4B5gFFXvdpaAhzDoJw=",
    title: "Western",
  ),
  Category(
    icon:
        "https://media.istockphoto.com/id/1344002306/photo/delicious-cheeseburger-with-cola-and-potato-fries-on-the-white-background-fast-food-concept.jpg?s=612x612&w=0&k=20&c=B8kZWz6zqmB11e4bIYt5rJ0U9aQ21AfZGgvT_JPIxqA=",
    title: "Fast Food",
  ),
  Category(
    icon:
        "https://media.istockphoto.com/id/500362775/photo/tiramisu-dessert.jpg?s=612x612&w=0&k=20&c=lWH9PvaN77Oi-aBd5szdOo2hK2RBTbdi_6HY8ExCfjg=",
    title: "Pastries",
  ),
];
