import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;
// Maak een alias zodat platformViewRegistry werkt

Widget iframeView(String viewId, double width, double height) {
  // Maak een alias zodat platformViewRegistry werkt

  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
    // Registreer de iframe view factory (doe dit maar 1x)
    // Dit maakt een iframe-element aan met jouw url

    final iframe = html.IFrameElement()
      ..width = '$width'
      ..height = '$height'
      ..src =
          'https://www.windfinder.com/widget/forecast/vereiniging_hylper_haven_friesland_netherlands'
      ..style.border = 'none';
    return iframe;
  });

  return SizedBox(
    width: width,
    height: height,
    child: HtmlElementView(viewType: viewId),
  );
}
