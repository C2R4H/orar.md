import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class time_widget extends StatefulWidget {
  double size;
  time_widget(this.size);
  @override
  time_widget_state createState() => time_widget_state();
}

class time_widget_state extends State<time_widget> {
  Timer? _timer;
  String _timeString = DateFormat('HH:mm').format(DateTime.now()).toString();
  String hour = DateFormat('HH').format(DateTime.now()).toString();
  String min = DateFormat('mm').format(DateTime.now()).toString();

  bool tick = false;
  void getTime() {
    final String formattedDateTime =
        DateFormat('HH:mm').format(DateTime.now()).toString();
    //THIS SET STATE MAY GIVE ERRORS (SOLVED)
    setState(() {
      _timeString = formattedDateTime;
      hour = _timeString.substring(0, 2);
      min = _timeString.substring(3, 5);
      tick = !tick;
    });
  }

  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getTime());
  }

  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: RichText(
      text: TextSpan(
        text: hour,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: widget.size,
        ),
        children: <TextSpan>[
          TextSpan(
            text: ':',
            style: TextStyle(color: tick ? Colors.white : Color(0xff121212)),
          ),
          TextSpan(text: min),
        ],
      ),
    ));
  }
}
