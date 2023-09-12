import 'package:flutter/material.dart';

class SizedUtil {
  static double minMaxWidhtPercent(
    BuildContext context,
    double percent,
    double minWith,
    double maxWith,
  ) {
    double width = MediaQuery.of(context).size.width * percent / 100;
    if (maxWith == 0) {
      maxWith = width;
    }
    if (minWith == 0) {
      minWith = width;
    }
    if (width < minWith) {
      return minWith;
    } else if (width > maxWith) {
      return maxWith;
    } else {
      return width;
    }
  }

  static double minMaxHegihtPercent(
    BuildContext context,
    double percent,
    double minHeight,
    double maxHeight,
  ) {
    double hegiht = MediaQuery.of(context).size.height * percent / 100;
    if (maxHeight == 0) {
      maxHeight = hegiht;
    }
    if (minHeight == 0) {
      minHeight = hegiht;
    }
    if (hegiht < minHeight) {
      return minHeight;
    } else if (hegiht > maxHeight) {
      return maxHeight;
    } else {
      return hegiht;
    }
  }
}
