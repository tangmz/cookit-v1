// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:pexels_null_safety/pexels_null_safety.dart';

class PexelsEngine {
  final _pexelsClient =
      PexelsClient('563492ad6f917000010000019acfce4535a444c1a0ef8652afbcbd3d');

  Future<String?> generateImageURL(String query) async {
    return (await _pexelsClient.searchPhotos(query))![0]!
        .sources['medium']!
        .link;
  }
}
