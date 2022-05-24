import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import '../../midend/models/lectie_model.dart';
import '../../midend/models/orar_model.dart';

class orar_screen extends StatefulWidget {
  OrarModel orar;
  orar_screen(this.orar);
  @override
  OrarScreenState createState() => OrarScreenState();
}

class OrarScreenState extends State<orar_screen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff090909),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: <Widget>[
              orarContainer(context, widget.orar.luni, 'Luni'),
              orarContainer(context, widget.orar.marti, 'Marti'),
              orarContainer(context, widget.orar.miercuri, 'Miercuri'),
              orarContainer(context, widget.orar.joi, 'Joi'),
              orarContainer(context, widget.orar.vineri, 'Vineri'),
            ],
          ),
        ],
      ),
    );
  }
}

class orarDialog extends StatelessWidget {
  List<LectieModel> day;
  String ziNume;
  orarDialog(this.day, this.ziNume);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Widget buildAnimatedProfesor(String text) => Marquee(
          text: text,
          velocity: 20,
          blankSpace: 40,
          pauseAfterRound: const Duration(seconds: 5),
          style: TextStyle(
            color: const Color(0xffa1a1a1),
            fontSize: width / 25,
            fontWeight: FontWeight.w300,
            decoration: TextDecoration.none,
          ),
        );

    Widget buildAnimatedText(String text) => Marquee(
          text: text,
          velocity: 20,
          blankSpace: 40,
          pauseAfterRound: const Duration(seconds: 5),
          style: TextStyle(
            fontSize: width / 22,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.none,
            color: Colors.white,
          ),
        );
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () {
          Navigator.pop(context);
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: Center(
              child: Hero(
                tag: day,
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 9.0, sigmaY: 9.0),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: width / 30, vertical: width / 60),
                          width: width / 1.20,
                          height: width / 3.4 + width / 6 * day.length,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color(0xff212121).withOpacity(0.85),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment(1.1,
                                  0.8), // 10% of the width, so there are ten blinds.
                              colors: <Color>[
                                Color(0xff313131),
                                Color(0xff181818)
                              ], // red to yellow
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ziNume,
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                      fontSize: width / 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Material(
                                    type: MaterialType.transparency,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.close_outlined,
                                          color: Colors.redAccent),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${day.first.startingTime} - ${day.last.endingTime}',
                                style: TextStyle(
                                  fontSize: width / 20,
                                  fontWeight: FontWeight.w300,
                                  color: const Color(0xffa1a1a1),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              SizedBox(
                                width: width / 1.20,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: day.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: width / 1.4,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${day[index].perecheId}',
                                                    style: TextStyle(
                                                      fontSize: width / 22,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      decoration:
                                                          TextDecoration.none,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(width: width / 35),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      day[index]
                                                                  .perecheNume
                                                                  .length <
                                                              18
                                                          ? Text(
                                                              day[index]
                                                                  .perecheNume,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    width / 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          : SizedBox(
                                                              width: width / 2,
                                                              height:
                                                                  width / 18,
                                                              child: buildAnimatedText(
                                                                  day[index]
                                                                      .perecheNume),
                                                            ),
                                                      SizedBox(
                                                          height: width / 85),
                                                      day[index]
                                                                  .profesorNume
                                                                  .length <
                                                              20
                                                          ? day[index].profesorNume !=
                                                                  'null'
                                                              ? Text(
                                                                  day[index]
                                                                      .profesorNume,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        width /
                                                                            25,
                                                                    color: Color(
                                                                        0xffA1A1A1),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .none,
                                                                  ),
                                                                )
                                                              : Container()
                                                          : SizedBox(
                                                              width: width / 2,
                                                              height: 18,
                                                              child: buildAnimatedProfesor(
                                                                  day[index]
                                                                      .profesorNume),
                                                            ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        day[index].startingTime,
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xffa1a1a1),
                                                          fontSize: width / 26,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .arrow_downward_outlined,
                                                        size: width / 30,
                                                        color: const Color(
                                                            0xff7DFF6C),
                                                      ),
                                                      Text(
                                                        day[index].endingTime,
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xffa1a1a1),
                                                          fontSize: width / 26,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          child: const Divider(
                                            indent: 0,
                                            color: Color(0xff616161),
                                            endIndent: 0,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget orarContainer(context, List<LectieModel> day, String ziNume) {
  double width = MediaQuery.of(context).size.width;

  if (width > 500) {
    width = 500;
  }

  Widget buildAnimatedText(String text) => Marquee(
        text: text,
        velocity: 20,
        blankSpace: 40,
        pauseAfterRound: const Duration(seconds: 5),
        style: TextStyle(
          fontSize: width / 25,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.none,
          color: Colors.white,
        ),
      );

  return Container(
    margin: EdgeInsets.symmetric(vertical: width / 150),
    child: Hero(
      tag: day,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          splashFactory: InkRipple.splashFactory,
          enableFeedback: true,
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false, // set to false
                pageBuilder: (_, __, ___) => orarDialog(day, ziNume),
              ),
            );
          },
          onLongPress: () {
            HapticFeedback.mediumImpact();
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false, // set to false
                pageBuilder: (_, __, ___) => orarDialog(day, ziNume),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
                child: Ink(
                  height: width / 2.1,
                  width: width / 2.1,
                  decoration: BoxDecoration(
                    color: const Color(0xff242424).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.1,
                          2.0), // 10% of the width, so there are ten blinds.
                      colors: <Color>[
                        Color(0xff272727),
                        Color(0xff212121),
                      ], // red to yellow
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(width / 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ziNume,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.white,
                            fontSize: width / 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${day.first.startingTime} - ${day.last.endingTime}',
                          style: TextStyle(
                            fontSize: width / 25,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xffa1a1a1),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const Divider(),
                        SizedBox(
                          height: width / 4.2,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: day.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: width / 2.8,
                                          child: Row(
                                            children: [
                                              Text(
                                                '${day[index].perecheId}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontSize: width / 30,
                                                ),
                                              ),
                                              SizedBox(width: width / 30),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  day[index]
                                                              .perecheNume
                                                              .length <
                                                          18
                                                      ? Text(
                                                          day[index]
                                                              .perecheNume,
                                                          style: TextStyle(
                                                            fontSize:
                                                                width / 25,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.white,
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                          ),
                                                        )
                                                      : SizedBox(
                                                          width: width / 3.4,
                                                          height: width / 18,
                                                          child: buildAnimatedText(
                                                              day[index]
                                                                  .perecheNume),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: width / 1.4,
                                      child: const Divider(
                                        indent: 0,
                                        color: Color(0xff616161),
                                        endIndent: 0,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
