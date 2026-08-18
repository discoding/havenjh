import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class BuienradarWidget extends StatefulWidget {
  const BuienradarWidget({super.key});

  @override
  State<BuienradarWidget> createState() => _BuienradarWidgetState();
}

class _BuienradarWidgetState extends State<BuienradarWidget> {
  static const String _viewId = 'buienradar-five-days';

  @override
  void initState() {
    super.initState();

    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) {
        final iframe = web.HTMLIFrameElement()
          ..src = 'https://image.buienradar.nl/2.0/image/animation/RadarMapRainWebMercatorNL'
          ..style.border = '0'
          ..style.width = '256px'
          ..style.height = '406px'
          ..allowFullscreen = true;

        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Buienradar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 406,
            width: double.infinity,
            child: Center(
              child: HtmlElementView(
                viewType: _viewId,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
