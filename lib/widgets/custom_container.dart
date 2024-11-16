import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key, 
  required this.child,
  this.padding,
  this.width,
  this.height, 
  this.backgroundColor});

  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 100,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: child,
      ),
    );
  }
}