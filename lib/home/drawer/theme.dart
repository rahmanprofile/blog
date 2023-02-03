import 'package:flutter/material.dart';

class MyTheme extends StatefulWidget {
  const MyTheme({Key? key}) : super(key: key);

  @override
  State<MyTheme> createState() => _MyThemeState();
}

class _MyThemeState extends State<MyTheme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Profile"),
      ),
    );
  }
}
