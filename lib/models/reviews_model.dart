// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

class Reviews {
  String? userName, userID, comments;
  double? ratings;
  Reviews({userName, userID, comments, ratings = 0.0})
      : userName = userName ?? '',
        userID = userID ?? '',
        comments = comments ?? 'No Comments',
        ratings = ratings ?? 0.0;
}
