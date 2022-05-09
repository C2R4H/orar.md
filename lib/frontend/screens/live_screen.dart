import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../../../midend/models/orar_model.dart';
import '../../../midend/models/lectie_model.dart';
import '../../../midend/bloc/live_bloc/live_bloc.dart';

class live_screen extends StatefulWidget {
  OrarModel orar;
  live_screen(this.orar);

  @override
  live_screen_state createState() => live_screen_state();
}

class live_screen_state extends State<live_screen> {
  double currentTime = 00.00;

  LiveBloc _liveBloc = LiveBloc();

  currentTimeChecker() {
    String currentTimeString =
        DateFormat('HH:mm').format(DateTime.now()).toString();
    currentTimeString = currentTimeString.replaceAll(':', '.');
    currentTime = double.parse(currentTimeString);
  }

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (Timer r) {
      if (!_liveBloc.isClosed) {
        currentTimeChecker();
        _liveBloc.add(LiveShowOrar(widget.orar, currentTime));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _liveBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _liveBloc,
      child: BlocBuilder<LiveBloc, LiveState>(
        bloc: _liveBloc,
        builder: (context, state) {
          if (state is LiveStateLoading) {
            return Container(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          if (state is LiveStateShowCurrentOrar) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  state.beforeLessons != null
                      ? Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: state.beforeLessons!.length,
                                itemBuilder: (context, index) {
                                  return lesson(
                                      context, state.beforeLessons![index]);
                                },
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  state.currentLessons != null
                      ? clesson(context, state.currentLessons!,
                          state.elapsedTime!, state.remainingTime!)
                      : Container(),
                  state.afterLessons != null
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            state.currentLessons != null &&
                                    state.afterLessons!.isNotEmpty
                                ? const Icon(
                                    Icons.subdirectory_arrow_right_rounded)
                                : Container(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: state.afterLessons!.length,
                                itemBuilder: (context, index) {
                                  return lesson(
                                      context, state.afterLessons![index]);
                                },
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }
}

Widget clesson(
    context, LectieModel lectie, String elapsedTime, String remainingTime) {
  double width = MediaQuery.of(context).size.width;

  return Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    height: width / 5,
    decoration: BoxDecoration(
        color: Color(0xff313131),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Row(children: [
      Container(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width / 50,
            horizontal: MediaQuery.of(context).size.width / 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            lectie.perecheNume != 'Recreatie'
                ? Row(
                    children: [
                      Icon(
                        Icons.school_rounded,
                        size: width / 20,
                        color: Color(0xffA1a1a1),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 50),
                      Text(lectie.profesorNume,
                          style: TextStyle(
                            color: Color(0xffa1a1a1),
                          )),
                    ],
                  )
                : Container(),
            Row(
              children: [
                Icon(
                  Icons.assignment_rounded,
                  size: width / 20,
                  color: Colors.white,
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 50),
                Container(
                  width: width / 3,
                  child: Text(
                    lectie.perecheNume,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            lectie.perecheNume != 'Recreatie'
                ? Row(
                    children: [
                      Icon(
                        Icons.edit_location_rounded,
                        size: width / 20,
                        color: Color(0xffa1a1a1),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 50),
                      Text(
                        'Cabinetul 44',
                        style: TextStyle(
                          color: Color(0xffa1a1a1),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
      Spacer(),
      Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width / 50,
            horizontal: MediaQuery.of(context).size.width / 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trecut',
              style: TextStyle(
                color: Color(0xffa1a1a1),
              ),
            ),
            Text(
              'Ramas',
              style: TextStyle(
                color: Color(0xffa1a1a1),
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: width / 80),
      Container(
        width: width / 3,
        decoration: BoxDecoration(
          color: Color(0xff212121),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width / 50,
              horizontal: MediaQuery.of(context).size.width / 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    elapsedTime,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff7DFF6C),
                    ),
                  ),
                  Icon(Icons.arrow_downward_rounded,
                      size: width / 20, color: Color(0xff1A1A1A)),
                  Text(
                    remainingTime,
                    style: TextStyle(
                      color: Color(0xff7DFF6C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    lectie.startingTime,
                    style: TextStyle(
                      color: Color(0xff616161),
                    ),
                  ),
                  lectie.perecheNume != 'Recreatie'
                      ? Icon(Icons.arrow_downward_rounded,
                          size: width / 20, color: Color(0xff7DFF6C))
                      : Container(),
                  lectie.perecheNume != 'Recreatie'
                      ? Text(
                          lectie.endingTime,
                          style: TextStyle(
                            color: Color(0xff616161),
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    ]),
  );
}

Widget lesson(context, LectieModel lectie) {

  double width = MediaQuery.of(context).size.width;

  Widget buildAnimatedProfesor(String text) => Marquee(
        text: text,
        velocity: 30,
        blankSpace: 50,
        pauseAfterRound: Duration(seconds: 3),
        style: TextStyle(
          color: Color(0xff676767),
        ),
      );

  Widget buildAnimatedNume(String text) => Marquee(
        text: text,
        velocity: 30,
        blankSpace: 50,
        pauseAfterRound: Duration(seconds: 5),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: width/18,
        ),
      );

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    height: lectie.profesorNume != '' ? width / 5 : null,
    decoration: const BoxDecoration(
        color: Color(0xff212121),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Row(children: [
      Container(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width / 40,
            horizontal: MediaQuery.of(context).size.width / 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: lectie.profesorNume!='null' ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
          children: [
            lectie.profesorNume.length!=1
                ? SizedBox(
                    width: width / 2.5,
                    height: width / 16,
                    child: lectie.perecheNume.length < 15
                        ? Text(
                            lectie.perecheNume,
                            style: TextStyle(
                              color: lectie.perecheNume == 'Recreatie'
                                  ? const Color(0xff616161)
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: width/18,
                            ),
                          )
                        : buildAnimatedNume(lectie.perecheNume),
                  )
                : Container(),
            lectie.profesorNume!='null' ?
            SizedBox(
              width: MediaQuery.of(context).size.width / 5,
              height: width / 20,
              child: lectie.profesorNume.length < 15
                  ? Text(
                      lectie.profesorNume,
                      style: TextStyle(
                        color: Color(0xff676767),
                        fontSize: width/22,
                      ),
                    )
                  : buildAnimatedProfesor(lectie.profesorNume),
            ):Container(),
          ],
        ),
      ),
      Spacer(),
      Container(
        width: width / 5,
        decoration: BoxDecoration(
          color: Color(0xff1A1A1A),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width / 50,
              horizontal: MediaQuery.of(context).size.width / 50),
          child: Column(
            mainAxisAlignment: lectie.profesorNume != ''
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: [
              Text(
                lectie.startingTime,
                style: TextStyle(
                  color: Color(0xff616161),
                ),
              ),
              lectie.profesorNume != ''
                  ? Icon(Icons.arrow_downward_rounded,
                      size: width / 20, color: Color(0xff7DFF6C))
                  : Container(),
              lectie.profesorNume != ''
                  ? Text(
                      lectie.endingTime,
                      style: TextStyle(
                        color: Color(0xff616161),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    ]),
  );
}
