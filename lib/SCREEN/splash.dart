import 'package:flutter/material.dart';

class splashscreen extends StatelessWidget{
  const splashscreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter chat'),
      ),
      body: const Center (child: Text('Loading...!'),),
    );
  }
}