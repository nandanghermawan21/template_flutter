import 'package:flutter/material.dart';
import 'package:enerren/util/system.dart';

class BasicComponent {
  static Widget avatar({
    double? size,
    VoidCallback? onTap,
    String? url,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: System.data.themeData?.colorScheme.secondary,
          border: Border.all(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(50))),
      height: size ?? 80,
      width: size ?? 80,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
          child: Image.network(
            url ?? "",
            fit: BoxFit.fitHeight,
            errorBuilder: (bb, o, st) => Container(
              color: Colors.transparent,
              child: Image.asset(
                "assets/avatar.png",
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget logoHorizontal() {
    return Image.asset(
      "assets/logo_suzuki_red.png",
      // color: Colors.white,
    );
  }
}
