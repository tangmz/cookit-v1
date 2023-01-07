// Programmer name: Tang Ming Ze
// Program name: Cookit
// Description: An Intelligent Recipe Content Sharing Platform
// First Written on: 20/10/2022
// Edited on: 1/6/2023

import 'package:openai_client/openai_client.dart';

class OpenAI {
  //create new client for AI
  final smartAIClient = OpenAIClient(
      configuration: const OpenAIConfiguration(
    apiKey: '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',
  ));

  Future<String> generateResult(String query) async {
    final completion = await smartAIClient.completions
        .create(
          model: 'text-davinci-003',
          prompt: query,
          temperature: 0.7,
          maxTokens: 300,
        )
        .data;
    return completion.choices.first.text.replaceAll('\n', '');
  }
}
