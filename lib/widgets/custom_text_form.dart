import 'package:flutter/material.dart';
import '../../app/app_export.dart';

class CustomTextForm extends StatelessWidget{
  const CustomTextForm({super.key,
  this.alignment,
  this.width,
  this.boxDecoration,
  this.scrollPadding,
  this.controller,
  this.inputType = TextInputType.text,
  this.inputAction = TextInputAction.next,
  this.focusNode,
  this.autofocus = false,
  this.textStyle,
  this.obscureText = false,
  this.readOnly = false,
  this.onTap,
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
  this.label,
  });

  final Alignment? alignment;
  final double? width;
  final BoxDecoration? boxDecoration;
  final TextEditingController? scrollPadding;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? textStyle;
  final bool? obscureText;
  final bool? readOnly;
  final VoidCallback? onTap;
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
  final FormFieldValidator<String>? validator;
  final String? label;

  @override
  Widget build(BuildContext context){
    return alignment!= null ? Align(
      alignment: alignment ?? Alignment.center,
      child: textFormFieldWidget(context),
    ) : textFormFieldWidget(context);
  }

  Widget textFormFieldWidget(BuildContext context) => Container(
      width: width ?? double.maxFinite,
      decoration: boxDecoration,
      child: TextFormField(
        scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        controller: controller,
        focusNode: focusNode,
        onTapOutside: (event){
          if(focusNode!=null){
            focusNode?.unfocus();
          }else {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        autofocus: autofocus!,
        style: textStyle ?? theme.textTheme.bodyLarge,
        obscureText: obscureText!,
        readOnly: readOnly!,
        onTap: (){
          onTap?.call();
        },
        textInputAction: inputAction,
        keyboardType: inputType,
        maxLines: maxLines ?? 1,
        decoration: decoration,
        validator: validator,
      ),
    );
  InputDecoration get decoration => InputDecoration(
    hintText: hintText ?? "",
    label: Text(label ?? ""),
    hintStyle: hintStyle ?? CustomText.bodyLargeErrorContainer,
    prefixIcon: prefix,
    prefixIconConstraints: prefixConstraints,
    suffixIcon: suffix,
    suffixIconConstraints: suffixConstraints,
    isDense: true,
    contentPadding: contentPadding ?? EdgeInsets.fromLTRB(10.h, 14.h, 10.h, 10.h),
    fillColor: fillColor?? appTheme.gray90001,
    filled: filled,
    border: borderDecoration ?? OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: appTheme.gray500),
      ),
    enabledBorder: borderDecoration ?? OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: appTheme.gray500),
      ),
    focusedBorder: (borderDecoration ?? OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      )).copyWith(
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1,),
      ),
  ); 
}