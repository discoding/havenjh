import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:web/web.dart' as web;

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final String _viewId = 'windfinder-iframe';

  @override
  void initState() {
    super.initState();

    // Register the iframe as a platform view (Flutter Web only)
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final iframe = html.IFrameElement()
        ..width = '320'
        ..height = '250'
        ..src =
            'https://www.windfinder.com/widget/forecast/vereiniging_hylper_haven_friesland_netherlands'
        ..style.border = 'none';
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Weer (Windfinder)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 320,
            height: 250,
            child: HtmlElementView(viewType: _viewId),
          ),
        ],
      ),
    );
  }
}
