import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/drawer_widget.dart';
import '../widgets/time_widget.dart';

import '../screens/live_screen.dart';
import '../screens/recreatie_screen.dart';
import '../screens/orar_screen.dart';

import '../../../midend/user_model.dart';

import '../../../midend/bloc/select_bloc/select_bloc.dart';
import '../../../midend/bloc/orar_bloc/orar_bloc.dart';

class MobileLayout extends StatefulWidget{
  final UserModel userModel;
  MobileLayout(this.userModel);
  @override
  _MobileLayoutState createState()=> _MobileLayoutState();
}


class _MobileLayoutState extends State<MobileLayout>{

  final OrarBloc _orarBloc = OrarBloc();
  final SelectBloc selectBloc = SelectBloc();

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    _orarBloc.add(GetOrarData(widget.userModel));

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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.userModel.grupaName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 15,
                                  ),
                                ),
                                Text(
                                  widget.userModel.colegiuName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 20,
                                    color: Color(0xff717171),
                                  ),
                                ),
                              ],
                            ),
                            time_widget(MediaQuery.of(context).size.width / 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const TabBar(
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
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Center(
                  child: Text(
                    'Timp',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Color(0xff717171),
                      fontSize: MediaQuery.of(context).size.height / 35,
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
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
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
              /*Positioned(
                          child: Container(
                            alignment: Alignment.center,
                            child: AdWidget(ad: myBanner),
                            width: myBanner.size.width.toDouble(),
                            height: myBanner.size.height.toDouble(),
                          ),
                        )*/
            ],
          ),
        ),
      ),
    );
  }
}
