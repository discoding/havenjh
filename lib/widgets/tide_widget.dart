import 'package:flutter/material.dart';

class TideWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text('Getijden',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Hoogwater: 12:43'),
            Text('Laagwater: 18:21'),
          ],
        ),
      ),
    );
  }
}
