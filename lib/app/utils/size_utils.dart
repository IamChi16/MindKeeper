// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

const num FIGMA_WIDTH = 375;
const num FIGMA_HEIGHT = 812;
const num FIGMA_STATUS_BAR = 0;

extension ResponsiveExtension on num{
  double get w => SizeUtils.width;
  double get h => ((this * w ) / FIGMA_HEIGHT);
  double get fSize => ((this * w ) / FIGMA_WIDTH);
}

extension FormatExtension on double{
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}){
    return this > 0 ? this : defaultValue.toDouble();
  }
}

enum DeviceType { mobile, tablet, desktop }

typedef ResponsiveBuild = Widget Function(
  BuildContext context, Orientation orientation, DeviceType deviceType);

class Sizer extends StatelessWidget {
  const Sizer({super.key, required this.builder});
  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(builder: (context, constraints){
      return OrientationBuilder(builder: (context, orientation){
        SizeUtils.setScreenSize(constraints, orientation);
        return builder(context, orientation, SizeUtils.deviceType);
      });
    });
  }
}

class SizeUtils {
  static late BoxConstraints boxConstraints;
  static late Orientation orientation;
  static late DeviceType deviceType;
  static late double width;
  static late double height;

  static void setScreenSize(
    BoxConstraints constraints, 
    Orientation orientation,
  ) {
    boxConstraints = constraints;
    orientation = orientation;
    if (orientation == Orientation.portrait) {
      width = boxConstraints.maxWidth.isNonZero(defaultValue: FIGMA_WIDTH);
      height = boxConstraints.maxHeight.isNonZero();
    } else {
      width = boxConstraints.maxHeight.isNonZero(defaultValue: FIGMA_WIDTH);
      height = boxConstraints.maxWidth.isNonZero();
    }
    deviceType = DeviceType.mobile;
  }
}

