import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../data/service/token_manager.dart';
//+998999999999
//user

Future<String> logIn(String username, String password) async {
  final response = await http.post(Uri.parse(Apis.baseUrl + Apis.loginApi),
      body: {"login": username, "password": password});
  print("Username: $username");
  print(response.body);
  if (response.statusCode == 200) {
    final id = jsonDecode(response.body)["user"]["id"];
    return id;
  }

  return "";
}

class ChatService {
  late IO.Socket socket;
  final String serverUrl;
  final void Function(List<String>) onMessagesReceived;
  final void Function() onConnected;
  final void Function() onDisconnected;
  final void Function(dynamic) onError;

  ChatService({
    required this.serverUrl,
    required this.onMessagesReceived,
    required this.onConnected,
    required this.onDisconnected,
    required this.onError,
  });

  void connect(String userId, String otherId) {
    print("UserId: $userId");
    socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      "query": {
        "userId": userId,
      }
    });

    socket.onConnect((_) {
      onConnected();
    });

    socket.onDisconnect((_) {
      onDisconnected();
    });

    socket.onError((error) {
      onError(error);
    });
    socket.emit("request-call", otherId);
    socket.on('message', (data) {
      if (data is Map &&
          data.containsKey('items') &&
          data['items'].containsKey('messages')) {
        List<String> messages =
            (data['items']['messages'] as List).map((m) => "").toList();
        onMessagesReceived(messages);
      } else {
        onError('Unexpected message format: $data');
      }
    });
    socket.on("not-online", (data) {
      print("Not online: $data");
    });

    socket.on("calling-process", (data) {
      print("Calling process: $data");
    });

    socket.on("audio-call", (data) {
      print("Audio Call: $data");
    });
    socket.connect();
  }

  void sendMessage(String content) {
    if (content.isNotEmpty) {
      socket.emit('message', {'sender': 'user', 'content': content});
    }
  }

  void disconnect() {
    socket.disconnect();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ChatService callService;
  @override
  void initState() {
    super.initState();
    callService = ChatService(
      serverUrl: 'http://192.168.2.132:3680',
      onMessagesReceived: (p0) {},
      onConnected: () {},
      onDisconnected: () {},
      onError: (p0) {},
    );
  }

  Future<void> connectCall() async {
    final a = await logIn("+998992222222", "user");
    final b = await logIn("+998990000001", "user");
    print("A: $a");
    print("B: $b");
    callService.connect(a, b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Home Page"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: connectCall,
        child: const Icon(Icons.phone),
      ),
    );
  }
}
