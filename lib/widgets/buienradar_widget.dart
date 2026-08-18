import 'dart:async';
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class BuienradarWidget extends StatefulWidget {
  const BuienradarWidget({super.key});

  @override
  State<BuienradarWidget> createState() => _BuienradarWidgetState();
}

class _BuienradarWidgetState extends State<BuienradarWidget> {
  Timer? _refreshTimer;

  int _version = 0;

  @override
  void initState() {
    super.initState();

    _registerBuienradar();

    // Iedere 5 minuten de volledige iframe opnieuw laden.
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) {
        if (mounted) {
          setState(() {
            _version++;
          });
        }
      },
    );
  }

  void _registerBuienradar() {
    ui_web.platformViewRegistry.registerViewFactory(
      'buienradar-five-days',
      (int viewId) {
        final iframe = web.HTMLIFrameElement()
          ..src = 'https://gadgets.buienradar.nl/gadget/radarfivedays'
          ..style.border = '0'
          ..style.width = '256px'
          ..style.height = '406px';

        return iframe;
      },
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
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
                key: ValueKey(_version),
                viewType: 'buienradar-five-days',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
