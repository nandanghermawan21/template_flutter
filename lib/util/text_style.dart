import 'package:flutter/material.dart';
import 'package:enerren/util/system.dart';

class TextStyles {
  TextStyle get basicLabel => TextStyle(
        color: System.data.color!.darkTextColor,
        fontFamily: System.data.font!.primary,
        fontSize: System.data.font!.m,
      );

  TextStyle get basicLightLabel => TextStyle(
        color: System.data.color!.lightTextColor,
        fontFamily: System.data.font!.primary,
        fontSize: System.data.font!.m,
      );

  TextStyle get basicLabelDanger => TextStyle(
        color: System.data.color!.dangerTextColor,
        fontFamily: System.data.font!.primary,
        fontSize: System.data.font!.m,
      );

  TextStyle get boldTitleLabel => TextStyle(
        color: System.data.color!.darkTextColor,
        fontFamily: System.data.font!.primary,
        fontSize: System.data.font!.l,
        fontWeight: FontWeight.bold,
      );

  TextStyle get boldTitleLightLabel => TextStyle(
        color: System.data.color!.lightTextColor,
        fontFamily: System.data.font!.primary,
        fontSize: System.data.font!.xxxl,
        fontWeight: FontWeight.bold,
      );
  TextStyle get boldTitleInfoLabel => TextStyle(
        color: System.data.color!.infoColor,
        fontFamily: System.data.font!.primary,
        fontSize: System.data.font!.l,
        fontWeight: FontWeight.bold,
      );

  TextStyle get boldTitleDangerLabel => TextStyle(
        color: System.data.color!.dangerColor,
        fontFamily: System.data.font!.primary,
        fontSize: System.data.font!.l,
        fontWeight: FontWeight.bold,
      );

  TextStyle get headLine1 => TextStyle(
        color: System.data.color!.darkTextColor,
        fontFamily: System.data.font!.primary,
        fontSize: System.data.font!.xxxl,
        fontWeight: FontWeight.normal,
      );

  TextStyle get headLine2 => TextStyle(
        color: System.data.color!.darkTextColor,
        fontFamily: System.data.font!.primary,
        fontSize: System.data.font!.xxl,
        fontWeight: FontWeight.normal,
      );

  TextStyle get headLine3 => TextStyle(
        color: System.data.color!.darkTextColor,
        fontFamily: System.data.font!.primary,
        fontSize: System.data.font!.xl,
        fontWeight: FontWeight.normal,
      );
}
