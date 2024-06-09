// {
//   "items": {
//     "id": "3b7b06b1-dc6c-4126-9990-eb6d52d081d8",
//     "title": "Test conversation",
//     "startDate": "2024-06-08T13:48:12.997Z",
//     "endDate": null,
//     "quickResponseTime": 0,
//     "duration": 0,
//     "closed": false,
//     "isAnswered": null,
//     "teacher": null,
//     "student": {
//       "id": "4b40308d-4e6e-4422-8630-41a916dda603"
//     },
//     "messages": [
//       {
//         "id": "f37b1e28-9634-44e0-bce7-1d679af47147",
//         "text": "Message 1",
//         "isViewed": false,
//         "date": "2024-06-08T13:57:00.063Z",
//         "image": null,
//         "repliedMessage": null
//       },
//       {
//         "id": "f849e46a-757e-407c-bb6d-a0047a1d1625",
//         "text": "Message 2",
//         "isViewed": false,
//         "date": "2024-06-08T13:57:07.873Z",
//         "image": null,
//         "repliedMessage": null
//       },
//       {
//         "id": "09bfe9ca-0f84-46d0-9fbf-3796b8352343",
//         "text": "Message 3",
//         "isViewed": false,
//         "date": "2024-06-08T13:57:14.288Z",
//         "image": null,
//         "repliedMessage": null
//       },
//       {
//         "id": "d8763ab5-8b50-4291-8118-23ee8ebdb0b9",
//         "text": "Message 4",
//         "isViewed": false,
//         "date": "2024-06-08T13:59:49.718Z",
//         "image": null,
//         "repliedMessage": {
//           "id": "f849e46a-757e-407c-bb6d-a0047a1d1625",
//           "text": "Message 2",
//           "date": "2024-06-08T13:57:07.873Z",
//           "image": null
//         }
//       }
//     ]
//   },
//   "meta": {
//     "totalItems": 2,
//     "itemCount": 1,
//     "itemsPerPage": 1,
//     "totalPages": 2,
//     "currentPage": 2
//   }
// }

import 'dart:convert';

class Conversation {
  final String id;
  final DateTime startDate;
  final DateTime? endDate;
  final int quickResponseTime;
  final int duration;
  final bool closed;
  final bool? isAnswered;
  final dynamic teacher; // Assuming teacher can be null or another type
  final Student student;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.quickResponseTime,
    required this.duration,
    required this.closed,
    this.isAnswered,
    required this.teacher,
    required this.student,
    required this.messages,
  });

  factory Conversation.fromJson(Map<String, Object?> json) {
    final id = json['id'] as String;
    final startDate = DateTime.parse(json['startDate'] as String);
    final endDate = json['endDate'] != null
        ? DateTime.parse(json['endDate'] as String)
        : null;
    final quickResponseTime = json['quickResponseTime'] as int;
    final duration = json['duration'] as int;
    final closed = json['closed'] as bool;
    final isAnswered = json['isAnswered'] != null;
    final teacher =
        json['teacher']; // Assuming teacher can be null or another type
    final student = Student.fromJson(json['student'] as Map<String, dynamic>);
    final messages = (json['messages'] as List<dynamic>)
        .map((message) => Message.fromJson(message))
        .toList();
    return Conversation(
        id: id,
        startDate: startDate,
        quickResponseTime: quickResponseTime,
        duration: duration,
        closed: closed,
        endDate: endDate,
        teacher: teacher,
        student: student,
        isAnswered: isAnswered,
        messages: messages);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'quickResponseTime': quickResponseTime,
      'duration': duration,
      'closed': closed,
      'isAnswered': isAnswered,
      'teacher': teacher,
      'student': student.toJson(), // Assuming Student has a toJson method
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}

class Student {
  final String id;

  Student({required this.id});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}

class Message {
  final String id;
  final String text;
  final bool isViewed;
  final DateTime date;
  final dynamic image; // Assuming image can be null or another type
  final int userRole; // 1 for sender, 2 for receiver
  final RepliendMessage? repliedMessage;

  Message({
    required this.id,
    required this.text,
    required this.isViewed,
    required this.date,
    required this.userRole,
    this.image,
    this.repliedMessage,
  });

  factory Message.fromJson(Map<String, Object?> json) {
    final id = json['id'] as String;
    final text = json['text'] as String;
    final isViewed = json['isViewed'] as bool;
    final date = DateTime.parse(json['date'] as String);
    final image = json['image'];
    final userRole = (json["user"] as Map)["role"] as int;
    final repliedMessage = json['repliedMessage'] != null
        ? RepliendMessage.fromJson(
            json['repliedMessage'] as Map<String, dynamic>)
        : null;

    return Message(
      id: id,
      text: text,
      isViewed: isViewed,
      date: date,
      image: image,
      userRole: userRole,
      repliedMessage: repliedMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isViewed': isViewed,
      'date': date.toIso8601String(),
      'image': image,
      'repliedMessage': repliedMessage?.toJson(),
    };
  }
}

class RepliendMessage {
  final String id;
  final String text;
  final DateTime date;
  final dynamic image;

  RepliendMessage({
    required this.id,
    required this.text,
    required this.date,
    this.image,
  });

  factory RepliendMessage.fromJson(Map<String, Object?> json) {
    final id = json['id'] as String;
    final text = json['text'] as String;
    final date = DateTime.parse(json['date'] as String);
    final image = json['image'];
    return RepliendMessage(
      id: id,
      text: text,
      date: date,
      image: image,
    );
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'text': text,
      'date': date.toIso8601String(),
      'image': image,
    });
  }
}
