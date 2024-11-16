import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (endsWith('.png')) {
      return ImageType.png;
    } else if (startsWith('http') || contains('https')) {
      return ImageType.network;
    } else if (startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.unknown;
    }
  }
}

enum ImageType { svg, png, network , file, unknown}

class CustomImageView extends StatelessWidget{
  const CustomImageView(
    {super.key, 
      this.imagePath,
      this.aligment,
      this.onTap,
      this.radius,
      this.margin,
      this.border,
      this.height,
      this.width,
      this.color,
      this.fit,
      this.placeHolder = 'assets/images/img_not_found.png'
    }
  );
  final String? imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final String? placeHolder;
  final Alignment? aligment;
  final VoidCallback? onTap;
  final BorderRadius? radius;
  final EdgeInsets? margin;
  final BoxBorder? border;
  @override
  Widget build(BuildContext context) {
    return aligment != null ? Align(
      alignment: aligment!,
      child: _buildWidget(),
    ) : _buildWidget();
  }

  Widget _buildWidget(){
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }
  //build image with border radius
  _buildCircleImage(){
    if (radius != null){
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }
  //build image with border and border radius
  _buildImageWithBorder(){
    if (border != null){
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }
  //build image view
  Widget _buildImageView(){
    if (imagePath != null) {
      switch(imagePath!.imageType){
        case ImageType.svg:
          return SizedBox(
            height: height,
            width: width,
            child: SvgPicture.asset(
              imagePath!,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              colorFilter: color != null ? ColorFilter.mode(
                color ?? Colors.transparent, BlendMode.srcIn) : null,
            ),
          );
        case ImageType.file:
          return Image.file(
            File(imagePath!),
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );
        case ImageType.network:
          return CachedNetworkImage(
            imageUrl: imagePath!,
            height: height,
            width: width,
            fit: fit,
            color: color,
            placeholder: (context, url) => SizedBox(
              height: 30,
              width: 30,
              child: LinearProgressIndicator(
                color: Colors.grey.shade200,
                backgroundColor: Colors.grey.shade100,
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              placeHolder!,
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
            ),
          );
        case ImageType.png:
        default:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );
      }
    }
    return const SizedBox();
  }
}