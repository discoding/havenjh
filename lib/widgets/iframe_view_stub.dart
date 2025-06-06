import 'package:flutter/material.dart';

Widget iframeView(String viewId, double width, double height) {
  return Center(
    child: Text(
      'Iframe wordt alleen getoond op Flutter Web.',
      style: TextStyle(fontSize: 16, color: Colors.grey),
    ),
  );
}
