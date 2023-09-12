import 'dart:async';

import 'package:flutter/widgets.dart';

class TickerComponent extends StatelessWidget {
  final WidgetBuilder child;
  final Duration duration;

  const TickerComponent({
    Key? key,
    this.duration = const Duration(seconds: 30),
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TickerComponentController _controller = TickerComponentController();

    _controller.start(duration);

    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (c, d, w) {
        return child(context);
      },
    );
  }
}

class TickerComponentController<T> extends ValueNotifier<TickerComponentValue> {
  TickerComponentController({TickerComponentValue? value})
      : super(value ?? TickerComponentValue());

  void start(Duration duration) {
    value.timer = Timer.periodic(duration, (timer) {
      notifyListeners();
    });
  }
}

class TickerComponentValue {
  Timer? timer;

  TickerComponentValue({this.timer});
}
