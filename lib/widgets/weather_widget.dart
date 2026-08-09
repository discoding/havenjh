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
          ..src =
              'https://www.windfinder.com/widget/forecast/vereiniging_hylper_haven_friesland_netherlands'
          ..style.border = '0'
          ..style.width = '100%'
          ..style.height = '100%'
          ..allowFullscreen = true;

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
            height: 500,
            width: double.infinity,
            child: HtmlElementView(
              viewType: _viewId,
            ),
          ),
        ],
      ),
    );
  }
}