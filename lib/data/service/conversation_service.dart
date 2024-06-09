import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:my_teacher_chat/data/service/token_manager.dart';

import '../../main.dart';

class ConversationService {
  final TokenManager manager;
  static const limit = 1;
  const ConversationService({required this.manager});

  Future<DataSource> getConversationById(int page, String chatId) async {
    try {
      final link =
          "$baseUrl/api/conversation/chat/$chatId?limit=$limit&page=$page";

      // const token =
      //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI0YjQwMzA4ZC00ZTZlLTQ0MjItODYzMC00MWE5MTZkZGE2MDMiLCJpYXQiOjE3MTc5MTEwMDksImV4cCI6MTcxNzkyNTQwOX0.nm4ogiWbpHmJoIbHhmsLQRImkFXz5vKzxl4ObSfNjXY";
      final result = await manager.dio.get(link);

      return DataSuccess(data: result.data, message: "Success");
    } catch (e) {
      debugPrint("Error: $e");
      return DataFailure(message: "Error: $e");
    }
  }

  Future<DataSource> createConversation(
      String chatId, String studentId, String title) async {
    print("Salom");
    const url = "$baseUrl/api/conversation";
    final data = jsonEncode(
      {
        "chat": chatId,
        "student": studentId,
        "title": title,
      },
    );
    print("1");
    final result = await manager.dio.post(
      url,
      data: data,
    );
    print("Result: ${result.data}");
    if (result.statusCode != 201) {
      return DataFailure(
          message: "Error: ${jsonDecode(result.data)['message']}");
    }
    return DataSuccess(data: result.data, message: "Success");
  }
}

class DataSource {
  final String message;
  const DataSource({
    required this.message,
  });
}

class DataFailure extends DataSource {
  const DataFailure({
    required super.message,
  });
}

class DataSuccess<T> extends DataSource {
  final T data;
  const DataSuccess({
    required this.data,
    required super.message,
  });
}
