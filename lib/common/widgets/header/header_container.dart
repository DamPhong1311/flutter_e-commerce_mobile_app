import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../curved_edges/curved_edges.dart';
import '../custom_shapes/circular_container.dart';

class WHeaderContainer {
  WHeaderContainer._();
   static ClipPath headerContainer({required Widget child,required double height}) {
    return ClipPath(
      clipper: WCustomCurveyEdges(),
      child: Container(
        color: KColors.primaryColor,
        height: height,
        child: Stack(
          children: [
            Positioned(
                top: -150,
                right: -250,
                child: WCircularContainer(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                )),
            Positioned(
                top: 100,
                right: -300,
                child: WCircularContainer(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                )),
            Positioned(
                top: 100,
                right: 250,
                child: WCircularContainer(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                )),
            child
          ],
        ),
      ),
    );
  }
}
