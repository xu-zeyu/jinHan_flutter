import 'package:flutter/widgets.dart';

const double kMySectionItemSpacing = 10;
const double kMySectionTwoColumnBreakpoint = 360;

double calculateMySectionItemWidth(
  BoxConstraints constraints, {
  double spacing = kMySectionItemSpacing,
  double twoColumnBreakpoint = kMySectionTwoColumnBreakpoint,
}) {
  final bool singleColumn = constraints.maxWidth < twoColumnBreakpoint;
  return singleColumn
      ? constraints.maxWidth
      : (constraints.maxWidth - spacing) / 2;
}
