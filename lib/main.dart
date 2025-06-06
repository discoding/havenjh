import 'package:flutter/material.dart';
import 'widgets/scheepvaartberichten_widget.dart';
import 'widgets/weather_widget.dart';
import 'widgets/tide_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maritieme Informatie',
      home: Scaffold(
        appBar: AppBar(title: Text('Maritieme Info')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth > 600
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: WeatherWidget()),
                        SizedBox(width: 16),
                        Expanded(child: TideWidget()),
                        SizedBox(width: 16),
                        Expanded(child: ScheepvaartberichtenWidget()),
                      ],
                    )
                  : ListView(
                      children: [
                        WeatherWidget(),
                        SizedBox(height: 16),
                        TideWidget(),
                        SizedBox(height: 16),
                        ScheepvaartberichtenWidget(),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
