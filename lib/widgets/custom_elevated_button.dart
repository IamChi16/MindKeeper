import 'package:flutter/material.dart';
import '../app/app_export.dart';
import 'base_button.dart';

class CustomElevatedButton extends BaseButton{
  const CustomElevatedButton({
    super.key,
    super.decoration,
    this.leftIcon,
    this.rightIcon,
    required super.text,
    super.onPressed,
    super.buttonStyle,
    super.textStyle,
    super.width,
    super.height,
    super.isDisabled,
    super.margin,
    super.alignment,
  });
  final Widget? leftIcon;
  final Widget? rightIcon;

  @override
  Widget build(BuildContext context){
    return alignment != null 
    ? Align(
      alignment: alignment ?? Alignment.center,
      child: buildElevatedButtonWidget) 
      : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
    height: height ?? 48.h,
    width: width ?? double.maxFinite,
    margin: margin,
    decoration: decoration,
    child: ElevatedButton(
      style: buttonStyle,
      onPressed: isDisabled ?? false ? null : onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leftIcon ?? const SizedBox.shrink(),
          Text(
            text,
            style: textStyle ?? CustomText.bodyLargeWhiteA7001,
          ),
          rightIcon ?? const SizedBox.shrink(),
        ],
      )
      ),
  );
}