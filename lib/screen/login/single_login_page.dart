import 'package:flutter/material.dart';

class SingleLoginPage extends StatelessWidget {
  const SingleLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Hello World - Single Player Mode',
            style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
