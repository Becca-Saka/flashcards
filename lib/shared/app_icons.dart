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
  static const String redoSpark = '$_svgBase/redo-spark.svg';
  static const String bookmark = '$_svgBase/bookmark.svg';
  static const String edit = '$_svgBase/edit.svg';
  static const String film = '$_svgBase/film.svg';
  static const String google = '$_svgBase/google.svg';
  static const String menuBurger = '$_svgBase/menu-burger.svg';
  static const String timeCheck = '$_svgBase/time-check.svg';
  static const String youtube = '$_svgBase/youtube.svg';
  static const String picture = '$_svgBase/picture.svg';
  static const String notifications = '$_svgBase/notifications.svg';
  static const String timePast = '$_svgBase/time-past.svg';
  static const String forward = '$_svgBase/forward.svg';
  static const String out = '$_svgBase/out.svg';
  static const String settings = '$_svgBase/settings.svg';
  static const String search = '$_svgBase/search.svg';
  static const String discovery = '$_svgBase/discovery.svg';
  static const String voice = '$_svgBase/voice.svg';
  static const String home = '$_svgBase/home.svg';
  static const String user = '$_svgBase/user.svg';
  static const String eyes = '$_svgBase/eye.svg';
  static const String eyeOutlined = '$_svgBase/eye-outlined.svg';
  static const String eyesClosed = '$_svgBase/eye-crossed.svg';
}
