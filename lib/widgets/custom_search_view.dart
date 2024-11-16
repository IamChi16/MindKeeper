import 'package:flutter/material.dart';
import '../../app/app_export.dart';

extension SearchViewStyleHelper on CustomSearchView {
  static OutlineInputBorder get outlineGray => OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.h),
        borderSide: BorderSide(color: appTheme.gray50001),
      );
}

class CustomSearchView extends StatelessWidget {
  const CustomSearchView({
    super.key,
    this.alignment,
    this.width,
    this.boxDecoration,
    this.scrollingPadding,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.inputStyle,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
  });

  final Alignment? alignment;
  final double? width;
  final BoxDecoration? boxDecoration;
  final TextEditingController? scrollingPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? textStyle;
  final TextStyle? inputStyle;
  final int? maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool? filled;
  final bool? obscureText;
  final bool? readOnly;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: searchViewWidget(context),
          )
        : searchViewWidget(context);
  }

  Widget searchViewWidget(BuildContext context) => Container(
        width: width ?? double.maxFinite,
        decoration: boxDecoration,
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          focusNode: focusNode,
          onTapOutside: (event) {
            if (focusNode != null) {
              focusNode?.unfocus();
            } else {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          autofocus: autofocus!,
          style: textStyle ?? CustomText.bodyLargeBluegray70001,
          obscureText: obscureText!,
          readOnly: readOnly!,
          onTap: () {
            onTap?.call();
          },
          keyboardType: TextInputType.text,
          maxLines: maxLines ?? 1,
          decoration: inputDecoration,
          validator: validator,
          onChanged: (String value) {
            onChanged!(value);
          },
        ),
      );

  InputDecoration get inputDecoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomText.bodyLargeWhiteA700,
        prefixIcon: prefix ??
            Container(
              margin: EdgeInsets.fromLTRB(60, 16.h, 20.h, 12.h),
              child: Icon(Icons.search, color: appTheme.gray50001),
            ),
        prefixIconConstraints: prefixConstraints ??
            const BoxConstraints(
              maxHeight: 50,
            ),
        suffixIcon: suffix ??
            Padding(
              padding: EdgeInsets.only(right: 15.h),
              child: IconButton(
                onPressed: () => controller!.clear(),
                icon: Icon(
                  Icons.clear,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
        suffixIconConstraints: suffixConstraints ??
            const BoxConstraints(
              maxHeight: 50,
            ),
        isDense: true,
        contentPadding: contentPadding ?? EdgeInsets.all(12.h),
        fillColor: fillColor ?? appTheme.indigo30001.withOpacity(0.16),
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.h),
              borderSide: BorderSide.none,
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.h),
              borderSide: BorderSide.none,
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.h),
            ).copyWith(
              borderSide: BorderSide(
                color: appTheme.indigo30001,
                width: 1,
              ),
            ),
      );
}
