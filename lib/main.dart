// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lost Ark Timer',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: const Home(),
    );
  }
}

// Events (more to be added)
final List<String> event = ['Alakkir'];
final List<String> image = ['assets/island_icons/alakkir.png'];

// real values of date/time
final now = DateTime.now().toUtc();
final String hour = DateFormat('Hms').format(now);
final String date = DateFormat('yyyy-MM-dd').format(now);
// get a big number to represent the current hour
int hourNum = int.parse(hour.replaceAll(':', ''));

// FAKE values to test
final nowFake = DateTime.parse('$date 02:49:00Z');
final String hourFake = DateFormat('Hms').format(nowFake);
int hourNumFake = int.parse(hourFake.replaceAll(':', ''));

// real times when alakkir island spawn
final List<DateTime> alakkirStart = [
  DateTime.parse('$date 02:50:00Z'),
  DateTime.parse('$date 05:50:00Z'),
  DateTime.parse('$date 11:50:00Z'),
  DateTime.parse('$date 17:50:00Z'),
  DateTime.parse('$date 20:50:00Z'),
  DateTime.parse('$date 23:50:00Z'),
];
final List<DateTime> alakkirEnd = [
  DateTime.parse('$date 02:59:59Z'),
  DateTime.parse('$date 05:59:59Z'),
  DateTime.parse('$date 11:59:59Z'),
  DateTime.parse('$date 17:59:59Z'),
  DateTime.parse('$date 20:59:59Z'),
  DateTime.parse('$date 23:59:59Z'),
];

// ignore: prefer_const_constructors
Duration remainingDuration = Duration(hours: 24);

bool happening = false;

void getRemaining() {

  // real values of date/time (get again if the function is run again e.g. when clock hits 0)
  final now = DateTime.now().toUtc();
  final String hour = DateFormat('Hms').format(now);

  // get a big number to represent the current hour
  int hourNum = int.parse(hour.replaceAll(':', ''));
  if (hourNum >= 000000 && hourNum < 025000) {
    remainingDuration = now.difference(alakkirStart[0]);
  } else if (hourNum >= 030000 && hourNum < 055000) {
    remainingDuration = now.difference(alakkirStart[1]);
  } else if (hourNum >= 060000 && hourNum < 115000) {
    remainingDuration = now.difference(alakkirStart[2]);
  } else if (hourNum >= 120000 && hourNum < 175000) {
    remainingDuration = now.difference(alakkirStart[3]);
  } else if (hourNum >= 180000 && hourNum < 205000) {
    remainingDuration = now.difference(alakkirStart[4]);
  } else if (hourNum >= 210000 && hourNum < 235000) {
    remainingDuration = now.difference(alakkirStart[5]);
  } else {
    if (hourNum >= 025000 && hourNum <= 025959) {
      remainingDuration = now.difference(alakkirEnd[0]);
      happening = true;
    } else if (hourNum >= 055000 && hourNum <= 055959) {
      remainingDuration = now.difference(alakkirEnd[1]);
      happening = true;
    } else if (hourNum >= 115000 && hourNum <= 115959) {
      remainingDuration = now.difference(alakkirEnd[2]);
      happening = true;
    } else if (hourNum >= 175000 && hourNum <= 175959) {
      remainingDuration = now.difference(alakkirEnd[3]);
      happening = true;
    } else if (hourNum >= 205000 && hourNum <= 205959) {
      remainingDuration = now.difference(alakkirEnd[4]);
      happening = true;
    } else if (hourNum >= 235000 && hourNum <= 235959) {
      remainingDuration = now.difference(alakkirEnd[5]);
      happening = true;
    }
  }
}

// to always fix leading 0s on clock
NumberFormat formatter = NumberFormat("00");

// building my own clock
int totalSeconds = remainingDuration.inSeconds.abs();
int seconds = totalSeconds % 60;
int totalMinutes = (totalSeconds / 60).floor();
int minutes = totalMinutes % 60;
int hours = (totalMinutes / 60).floor();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer? timer;

// setting the timer to run the clock properly
// (could also have been done with updating the remainingDuration every minute or second...)
// I don't really know why I've done this way
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        seconds--;
        if (seconds < 0) {
          if (seconds < 0 && minutes < 0 && hours < 0) {
            getRemaining();
          }
          minutes--;
          seconds = 59;
          if (minutes < 0) {
            hours--;
            minutes = 59;
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    getRemaining();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Lost Ark Timer'))),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: event.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 5,
                  child: Card(
                    child: ListTile(
                        tileColor: Colors.black12,
                        leading: Image.asset('assets/island_icons/alakkir.png'),
                        title: Text(event[index]),
                        subtitle: happening
                            ? Text(
                                'The event gonna end in ${formatter.format(hours)}:${formatter.format(minutes)}:${formatter.format(seconds)}')
                            : Text(
                                'The event gonna start in ${formatter.format(hours)}:${formatter.format(minutes)}:${formatter.format(seconds)}')),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
