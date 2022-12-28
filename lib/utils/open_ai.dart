import 'package:flutter/material.dart';
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
          model: 'text-ada-001',
          prompt: query,
          temperature: 0.7,
          maxTokens: 300,
        )
        .data;
    return completion.choices.first.text.replaceAll('\n', '');
  }
}
