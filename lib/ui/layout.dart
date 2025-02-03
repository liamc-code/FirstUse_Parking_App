import 'package:flutter/material.dart';
//File that will be the layout for the other screens

class BaseLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  const BaseLayout({
    required this.title,
    required this.body,
    this.floatingActionButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style:
                Theme.of(context).textTheme.titleLarge // use themes text style
            ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
