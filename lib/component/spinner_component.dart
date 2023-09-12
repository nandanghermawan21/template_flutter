import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:enerren/util/system.dart';

class SpinnerComponent extends StatelessWidget {
  final SpinnerController controller;
  final String decimalSeparator;
  final int numberOfDecimal;
  final double? minValue;
  final double? maxValue;

  const SpinnerComponent({
    Key? key,
    required this.controller,
    this.decimalSeparator = ".",
    this.numberOfDecimal = 2,
    this.minValue,
    this.maxValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.value.minValue = minValue;
    controller.value.maxValue = maxValue;

    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              controller.decrease(decimalSeparator, numberOfDecimal);
            },
            onLongPressStart: (detail) {
              controller.autoDecrease(decimalSeparator, numberOfDecimal);
            },
            onLongPressEnd: (detail) {
              controller.cancelAutoInorDecrease();
            },
            child: Container(
              width: 30,
              height: 30,
              color: Colors.transparent,
              child: Icon(
                Icons.remove,
                color: System.data.color!.link,
              ),
            ),
          ),
          Container(
            width: 100,
            height: 30,
            color: Colors.white,
            child: inputText(),
          ),
          GestureDetector(
            onTap: () {
              controller.increase(decimalSeparator, numberOfDecimal);
            },
            onLongPressStart: (detail) {
              controller.autoIncrease(decimalSeparator, numberOfDecimal);
            },
            onLongPressEnd: (detail) {
              controller.cancelAutoInorDecrease();
            },
            child: Container(
              width: 30,
              height: 30,
              color: Colors.transparent,
              child: Icon(
                Icons.add,
                color: System.data.color!.link,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputText() {
    return TextField(
      controller: controller.value.textController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp('[0-9]+[$decimalSeparator]{0,1}[0-9]*')),
      ],
      onChanged: (val) {
        controller.value.value =
            double.parse(val.replaceAll(decimalSeparator, "."));
      },
    );
  }
}

class SpinnerController extends ValueNotifier<SpinnerValue> {
  SpinnerController({SpinnerValue? value})
      : super(
          value ?? SpinnerValue(),
        );

  Timer? autoinordecrease;

  void increase(String decimalSeparator, int numberOfSecimal) {
    if (value.maxValue != null && (value.value + 1) > (value.maxValue ?? 0)) {
      return;
    }

    value.value = value.value + 1;
    value.textController.text = value.value
        .toStringAsFixed(numberOfSecimal)
        .replaceAll(".", decimalSeparator);
  }

  void decrease(String decimalSeparator, int numberOfSecimal) {
    if (value.minValue != null && (value.value - 1) < (value.minValue ?? 0)) {
      return;
    }

    value.value = value.value - 1;
    value.textController.text = value.value
        .toStringAsFixed(numberOfSecimal)
        .replaceAll(".", decimalSeparator);
  }

  void autoDecrease(String decimalSeparator, int numberOfSecimal) {
    autoinordecrease = Timer.periodic(const Duration(milliseconds: 10), (t) {
      decrease(decimalSeparator, numberOfSecimal);
    });
  }

  void autoIncrease(String decimalSeparator, int numberOfSecimal) {
    autoinordecrease = Timer.periodic(const Duration(milliseconds: 10), (t) {
      increase(decimalSeparator, numberOfSecimal);
    });
  }

  void cancelAutoInorDecrease() {
    autoinordecrease?.cancel();
  }
}

class SpinnerValue {
  TextEditingController textController = TextEditingController();
  double value = 0;
  double? minValue;
  double? maxValue;
}
