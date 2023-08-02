import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

class AdaptableStopwatch extends StatefulWidget {
  const AdaptableStopwatch({
    super.key,
    required this.stopwatch,
  });

  final Stopwatch stopwatch;

  @override
  State<AdaptableStopwatch> createState() => _AdaptableStopwatchState();
}

class _AdaptableStopwatchState extends State<AdaptableStopwatch>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  int elapsedTime = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) =>
        setState(() => elapsedTime = widget.stopwatch.elapsed.inSeconds));
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${elapsedTime ~/ 60 > 9 ? '' : '0'}${elapsedTime ~/ 60} : ${elapsedTime % 60 > 9 ? '' : '0'}${elapsedTime % 60}',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
