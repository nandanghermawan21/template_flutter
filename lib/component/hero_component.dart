import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:enerren/util/system.dart';
import 'package:enerren/util/enum.dart';

class HeroComponent extends StatelessWidget {
  final String? source;
  final HeroSourceMode? mode;
  final String? tagImage;
  final Color? backgroundColor;
  final Widget? bottomWidget;

  const HeroComponent({
    Key? key,
    this.source,
    this.mode = HeroSourceMode.base64,
    this.tagImage,
    this.backgroundColor,
    this.bottomWidget,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          PhotoView(
            enableRotation: true,
            imageProvider: childBuilder(mode ?? HeroSourceMode.base64),
            errorBuilder: (b, o, s) {
              return const Center(
                child: Icon(Icons.image_not_supported),
              );
            },
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(20),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Text(
                          (tagImage ?? ""),
                          style: System.data.textStyles!.boldTitleLightLabel,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(25),
              child: bottomWidget,
            ),
          )
        ],
      ),
    );
  }

  ImageProvider childBuilder(HeroSourceMode mode) {
    switch (mode) {
      case HeroSourceMode.file:
        return FileImage(File(source ?? ""));
      case HeroSourceMode.network:
        return NetworkImage(source ?? "");
      default:
        return MemoryImage(
          base64.decode(source ?? ""),
        );
    }
  }
}
