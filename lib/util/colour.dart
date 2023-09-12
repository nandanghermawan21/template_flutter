import 'package:flutter/material.dart';

abstract class Colour {


  Color get background => const Color(0xffe9ecef);
  Color get darkBackground => const Color.fromARGB(255, 0, 30, 89);
  Color get lightBackground => const Color(0xffF0F6FF);
  Color get darkBackgroundBorder => const Color(0xff707070);
  Color get primaryColor => const Color(0xFF003399);
  Color get primaryColorLight => const Color.fromARGB(255, 2, 37, 109);
  Color get link => const Color(0xFF003399);
  Color get unselected => const Color(0xff707070);
  Color get darkTextColor => const Color(0xff000000);
  Color get lightTextColor => const Color(0XFFEEEEEE);
  Color get dangerTextColor => const Color(0XFFDB5065);
  Color get dangerColor => const Color(0XFFDB5065);
  Color get infoColor => const Color(0XFF17A383);
  Color get warningColor => const Color.fromARGB(255, 255, 204, 0);
  Color get greyColor => const Color.fromARGB(255, 160, 158, 158);

}
