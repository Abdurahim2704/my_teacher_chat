import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final messages = List.generate(100, (index) => "Bu message $index");
  final userMessages = <String>[];
  final controller = ScrollController();
  final limit = 20;
  @override
  void initState() {
    super.initState();
    userMessages.addAll(messages.take(20));
    messages.removeRange(0, 20);
    controller.addListener(() async {
      if (controller.hasClients) {
        print("Pixels: ${controller.position.pixels}");
        print("Viewport: ${controller.position.maxScrollExtent}");
        if (controller.offset >= controller.position.maxScrollExtent &&
            !controller.position.outOfRange) {
          userMessages.addAll(messages.take(20));
          await Future.delayed(const Duration(seconds: 1));
          messages.removeRange(0, 20);
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        reverse: true,
        controller: controller,
        itemBuilder: (context, index) {
          final item = userMessages[index];
          return ListTile(
            title: Text(item),
          );
        },
        itemCount: userMessages.length,
      ),
    );
  }
}
