import 'package:flutter/material.dart';

class TimeSelect extends StatelessWidget {
  const TimeSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Time"),
      ),
      body: Center(
        child: const Text('Time selection page'),
      ),
    );
  }
}
