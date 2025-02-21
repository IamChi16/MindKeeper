import 'package:flutter/material.dart';
import '../app/app_export.dart';
import 'base_button.dart';

class CustomOutlinedButton extends BaseButton{
    const CustomOutlinedButton({
        super.key, 
        super.decoration,
        this.leftIcon,
        this.rightIcon,
        this.label,
        super.onPressed,
        super.buttonStyle,
        super.textStyle,
        super.isDisabled,
        super.alignment,
        super.width,
        super.height,
        super.margin,
        required super.text,});
    final Widget? leftIcon;
    final Widget? rightIcon;
    final Widget? label;

    @override
    Widget build(BuildContext context) {
        return alignment != null
            ? Align(
                alignment: alignment ?? Alignment.center,
                child: buildOutlinedButton
            )
            : buildOutlinedButton;
    }

    Widget get buildOutlinedButton => Container(
        height: height ?? 48.h,
        width: width ?? double.maxFinite,
        margin: margin,
        decoration: decoration,
        child: OutlinedButton(
            style: buttonStyle,
            onPressed: isDisabled ?? false ? null : onPressed ?? () {},
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    leftIcon ?? const SizedBox.shrink(),
                    Text(
                        text,
                        style: textStyle ?? theme.textTheme.bodyLarge,
                    ),
                    rightIcon ?? const SizedBox.shrink(),
                ],
            ),
        ),
    );
}