import 'package:flutter/material.dart';

class LayoutController extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;

  LayoutController({required this.mobileBody, required this.desktopBody});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print(constraints);
        if (constraints.maxWidth < 600) {
          return mobileBody;
        } else {
          return desktopBody;
        }
      },
    );
  }
}
