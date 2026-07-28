import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  static const String _viewId = 'windfinder-iframe';

  @override
  void initState() {
    super.initState();

    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) {
        final iframe = web.HTMLIFrameElement()
          ..width = '320'
          ..height = '250'
          ..src =
              'https://www.windfinder.com/widget/forecast/vereiniging_hylper_haven_friesland_netherlands'
          ..style.border = 'none';

        return iframe;
      },
    );
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 320,
            height: 250,
            child: HtmlElementView(
              viewType: _viewId,
            ),
          ),
        ],
      ),
    );
  }
}
