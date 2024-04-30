import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIcons extends StatelessWidget {
  final String icon;
  final double size;
  final Color? color;
  final VoidCallback? onTap;
  const AppIcons({
    required this.icon,
    super.key,
    this.size = 16,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        icon,
        width: size,
        height: size,
        color: color,
      ),
    );
  }
}

abstract class AppIconData {
  static const String _svgBase = 'assets/svgs';
  static const String back = '$_svgBase/back.svg';
  static const String edit = '$_svgBase/edit.svg';
  static const String google = '$_svgBase/google.svg';
  static const String settings = '$_svgBase/settings.svg';
  static const String user = '$_svgBase/user.svg';
  static const String eyeOutlined = '$_svgBase/eye-outlined.svg';
  static const String eyesClosed = '$_svgBase/eye-crossed.svg';
  static const String collection = '$_svgBase/collection.svg';
  static const String goBack = '$_svgBase/go-back.svg';
  static const String empty = '$_svgBase/empty.svg';
}
