import 'package:flutter/material.dart';
import 'package:ecommerece_flutter_app/common/widgets/curved_edges/curved_edges.dart';

class CurvedEdgesWidget extends StatelessWidget {
  const CurvedEdgesWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WCustomCurveyEdges(),
      child: child,
    );
  }
}
