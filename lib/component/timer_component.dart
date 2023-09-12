import 'dart:async';
import 'package:flutter/material.dart';
import 'package:enerren/util/system.dart';

class TimerComponent extends StatelessWidget {
  final TimerController controller;
  final Widget Function(TimerValue value)? onIdle;
  final Widget Function(TimerValue value)? onRunning;
  final Widget Function(TimerValue value)? onStop;
  final Widget Function(TimerValue value)? onFinish;

  const TimerComponent({
    Key? key,
    required this.controller,
    this.onIdle,
    this.onRunning,
    this.onStop,
    this.onFinish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TimerValue>(
      valueListenable: controller,
      builder: (c, d, w) {
        return Container(
          child: childBuilder(controller.value),
        );
      },
    );
  }

  Widget childBuilder(TimerValue value) {
    switch (value.state) {
      case TimerState.onIdle:
        return onIdle != null ? onIdle!(value) : idle(value);
      case TimerState.onRunning:
        return onRunning != null ? onRunning!(value) : running(value);
      case TimerState.onStop:
        return onStop != null ? onStop!(value) : stop(value);
      case TimerState.onFinish:
        return onFinish != null ? onFinish!(value) : finish(value);
    }
  }

  Widget idle(TimerValue value) {
    return const SizedBox();
  }

  Widget running(TimerValue value) {
    return Text(
      "${value.dayLeft} : ${value.hourLeft} : ${value.minuteLeft} : ${value.secondLeft}",
      style: const TextStyle(
        color: Colors.blue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget stop(TimerValue value) {
    return Text(
      "${value.dayLeft} : ${value.hourLeft} : ${value.minuteLeft} : ${value.secondLeft}",
      style: const TextStyle(
        color: Colors.red,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget finish(TimerValue value) {
    return Text(
      System.data.strings!.timeLeft,
      style: const TextStyle(
        color: Colors.red,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class TimerController extends ValueNotifier<TimerValue> {
  TimerController({TimerValue? value})
      : super(
          value ?? TimerValue(),
        );

  Timer? _timer;

  void start({
    Duration? duration,
    VoidCallback? onTick,
  }) {
    _timer?.cancel();
    if (duration != null) {
      value.duration = duration;
      commit();
    }
    value.state = TimerState.onRunning;
    commit();
    const period = Duration(milliseconds: 1);
    _timer = Timer.periodic(
      period,
      (t) {
        if (value.duration.inSeconds > 0) {
          value.duration = Duration(
            milliseconds: (value.duration.inMilliseconds - 1),
          );
          if (onTick != null) {
            onTick();
          }
          commit();
        } else {
          finish();
        }
      },
    );
  }

  void stop() {
    _timer?.cancel();
    value.state = TimerState.onStop;
    commit();
  }

  void finish() {
    _timer?.cancel();
    value.state = TimerState.onFinish;
    commit();
  }

  void idle() {
    _timer?.cancel();
    value.state = TimerState.onIdle;
    commit();
  }

  void commit() {
    notifyListeners();
  }
}

class TimerValue {
  TimerState state = TimerState.onIdle;
  Duration duration = const Duration(seconds: 0);

  int get dayLeft {
    return duration.inDays;
  }

  int get hourLeft {
    return duration.inHours - (Duration(days: duration.inDays).inHours);
  }

  int get minuteLeft {
    return duration.inMinutes - (Duration(hours: duration.inHours).inMinutes);
  }

  int get secondLeft {
    return duration.inSeconds -
        (Duration(minutes: duration.inMinutes).inSeconds);
  }

  int get miliSecondLeft {
    return duration.inMilliseconds -
        (Duration(seconds: duration.inSeconds).inMilliseconds);
  }

  int get microSecondLeft {
    return duration.inMilliseconds -
        (Duration(milliseconds: duration.inMilliseconds).inMicroseconds);
  }
}

enum TimerState {
  onIdle,
  onRunning,
  onStop,
  onFinish,
}
