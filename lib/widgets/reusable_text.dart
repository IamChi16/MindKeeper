import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  const ReusableText(
      {super.key,
      this.textAlign,
      required this.text,
      required this.style,});
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  
@override
  Widget build(BuildContext context){
    return Text(
      text,
      style: style,
      maxLines: 1,
      textAlign: textAlign,
      softWrap: false,
      overflow: TextOverflow.fade,
    );
  }

}