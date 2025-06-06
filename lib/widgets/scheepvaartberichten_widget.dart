import 'package:flutter/material.dart';

class ScheepvaartberichtenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Scheepvaartmededelingen',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('⚠️ Sluis gestremd van 14:00-16:00'),
            Text('🟢 Vaargeul vrijgegeven bij km 345'),
          ],
        ),
      ),
    );
  }
}
