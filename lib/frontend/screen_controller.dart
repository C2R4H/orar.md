import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';

import 'widgets/drawer_widget.dart';
import 'widgets/time_widget.dart';

import 'screens/live_screen.dart';
import 'screens/recreatie_screen.dart';
import 'screens/orar_screen.dart';
import 'screens/newUser_screen.dart';

import '../../midend/bloc/auth_bloc/auth_bloc.dart';
import '../../midend/bloc/select_bloc/select_bloc.dart';
import '../../midend/bloc/orar_bloc/orar_bloc.dart';
import '../../midend/user_model.dart';

class screen_controller extends StatefulWidget {
  @override
  screen_controller_state createState() => screen_controller_state();
}

class screen_controller_state extends State<screen_controller> {
  String _timeString = DateFormat('HH:mm').format(DateTime.now()).toString();

  SelectBloc selectBloc = SelectBloc();
  final AuthBloc _authBloc = AuthBloc();
  final OrarBloc _orarBloc = OrarBloc();

  void _getTime() {
    final String formattedDateTime =
        DateFormat('HH:mm').format(DateTime.now()).toString();
    //REMOVED SETSTATE BECAUSE ITS BREAKING THE DRAWER
    _timeString = formattedDateTime;
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  @override
  void initState() {
    _authBloc.add(AppStarted());
    super.initState();
    myBanner.load();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => _authBloc,
      child: BlocBuilder<AuthBloc, AuthState>(
          bloc: _authBloc,
          builder: (context, state) {
            if (state is AuthStateLoading) {
              return CircularProgressIndicator.adaptive();
            }
            if (state is AuthStateUnaunthenticated) {
              return newUser_screen();
            }
            if (state is AuthStateAuthenticated) {
              _orarBloc.add(GetOrarData(state.userModel));
              return DefaultTabController(
                length: 3,
                child: BlocProvider(
                  create: (_) => selectBloc,
                  child: Scaffold(
                    drawer: drawerWidget(context, selectBloc),
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: Color(0xff121212),
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(height / 8),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.userModel.grupaName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  15,
                                            ),
                                          ),
                                          Text(
                                            state.userModel.colegiuName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  20,
                                              color: Color(0xff717171),
                                            ),
                                          ),
                                        ],
                                      ),
                                      time_widget(
                                          MediaQuery.of(context).size.width /
                                              8),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            TabBar(
                              indicatorColor: Color(0xff7DFF6C),
                              unselectedLabelColor: Color(0xff515151),
                              tabs: <Widget>[
                                Tab(text: "Orar"),
                                Tab(text: "Live"),
                                Tab(text: "Sunete")
                              ],
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: Text(
                              'Timp',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Color(0xff717171),
                                fontSize:
                                    MediaQuery.of(context).size.height / 35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Color(0xff090909),
                    body: Stack(
                        alignment: Alignment.bottomCenter,
                      children: [
                        BlocProvider(
                          create: (context) => _orarBloc,
                          child: BlocBuilder<OrarBloc, OrarState>(
                              bloc: _orarBloc,
                              builder: (context, state) {
                                if (state is OrarStateLoading) {
                                  return Container(
                                    child: Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    ),
                                  );
                                }
                                if (state is OrarStateLoadedData) {
                                  return TabBarView(
                                    children: [
                                      orar_screen(state.orar),
                                      live_screen(state.orar),
                                      recreatie_screen(state.perechiSunet),
                                    ],
                                  );
                                }
                                if (state is OrarStateError) {
                                  return Container(
                                    child: Center(
                                      child: Text('There was an error'),
                                    ),
                                  );
                                }
                                return Container();
                              }),
                        ),
                        Positioned(
                          child: Container(
                            alignment: Alignment.center,
                            child: AdWidget(ad: myBanner),
                            width: myBanner.size.width.toDouble(),
                            height: myBanner.size.height.toDouble(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          }),
    );
  }
}
