import 'dart:convert';

import 'package:my_teacher_chat/data/models/message.dart';
import 'package:my_teacher_chat/data/service/conversation_service.dart';
import 'package:my_teacher_chat/data/service/token_manager.dart';
import 'package:test/test.dart';

final json = {
  "items": {
    "id": "3b7b06b1-dc6c-4126-9990-eb6d52d081d8",
    "title": "Test conversation",
    "startDate": "2024-06-08T13:48:12.997Z",
    "endDate": null,
    "quickResponseTime": 0,
    "duration": 0,
    "closed": false,
    "isAnswered": null,
    "teacher": null,
    "student": {"id": "4b40308d-4e6e-4422-8630-41a916dda603"},
    "messages": [
      {
        "id": "f37b1e28-9634-44e0-bce7-1d679af47147",
        "text": "Message 1",
        "isViewed": false,
        "date": "2024-06-08T13:57:00.063Z",
        "image": null,
        "user": {"role": 1},
        "repliedMessage": null
      },
      {
        "id": "f849e46a-757e-407c-bb6d-a0047a1d1625",
        "text": "Message 2",
        "isViewed": false,
        "date": "2024-06-08T13:57:07.873Z",
        "image": null,
        "user": {"role": 1},
        "repliedMessage": null
      },
      {
        "id": "09bfe9ca-0f84-46d0-9fbf-3796b8352343",
        "text": "Message 3",
        "isViewed": false,
        "date": "2024-06-08T13:57:14.288Z",
        "image": null,
        "user": {"role": 1},
        "repliedMessage": null
      },
      {
        "id": "d8763ab5-8b50-4291-8118-23ee8ebdb0b9",
        "text": "Message 4",
        "isViewed": false,
        "date": "2024-06-08T13:59:49.718Z",
        "image": null,
        "user": {"role": 1},
        "repliedMessage": {
          "id": "f849e46a-757e-407c-bb6d-a0047a1d1625",
          "text": "Message 2",
          "date": "2024-06-08T13:57:07.873Z",
          "image": null
        }
      }
    ]
  },
  "meta": {
    "totalItems": 2,
    "itemCount": 1,
    "itemsPerPage": 1,
    "totalPages": 2,
    "currentPage": 2
  }
};
void main() {
  group(
    ConversationService,
    timeout: const Timeout(Duration(seconds: 30)),
    () {
      final manager = TokenManager();

      test(
        'get conversation by id',
        () async {
          final service = ConversationService(manager: manager);
          final result = await service.getConversationById(
              2, "6d834b47-d9d5-4c05-a6bb-8ab6e8e3e0bd");
          if (result is DataSuccess) {
            final data = jsonDecode(jsonEncode(result.data["items"]!));
            final conversation =
                Conversation.fromJson(data as Map<String, Object?>);
            print(conversation.messages);
          }

          // json = (result as DataSuccess).data;
          // print(json);
          // expect(result.data, isA<Map<String, dynamic>>());
        },
      );

      test("Conversation fromJson", () {
        final conversation = Conversation.fromJson(json["items"]!);
      });

      test("Create conversation", () async {
        final service = ConversationService(manager: manager);
        final result = await service.createConversation(
            "6d834b47-d9d5-4c05-a6bb-8ab6e8e3e0bd",
            "4b40308d-4e6e-4422-8630-41a916dda603",
            "Salom men inliz tili o'rganmoqchiman");
        if (result is DataSuccess) {
          print("Data Success: ${result.data}");
        }
        print(result);
      });
    },
  );
}
