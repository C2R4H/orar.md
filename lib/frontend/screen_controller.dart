import 'package:flutter/material.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'layouts/mobile_layout.dart';
import 'layouts/desktop_layout.dart';
import 'layout_controller.dart';

import 'screens/newUser_screen.dart';

import '../../midend/bloc/auth_bloc/auth_bloc.dart';
import '../../midend/bloc/select_bloc/select_bloc.dart';

class screen_controller extends StatefulWidget {
  @override
  screen_controller_state createState() => screen_controller_state();
}

class screen_controller_state extends State<screen_controller> {
  SelectBloc selectBloc = SelectBloc();

  final AuthBloc _authBloc = AuthBloc();

  /*final BannerAd myBanner = BannerAd(
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );*/

  @override
  void initState() {
    _authBloc.add(AppStarted());
    super.initState();
    //myBanner.load();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => _authBloc,
      child: BlocBuilder<AuthBloc, AuthState>(
          bloc: _authBloc,
          builder: (context, state) {
            if (state is AuthStateLoading) {
              return const CircularProgressIndicator.adaptive();
            }
            if (state is AuthStateUnaunthenticated) {
              return newUser_screen();
            }
            if (state is AuthStateAuthenticated) {
              // FROM HERE WE NEED TO ADD LAYOUT BUILDER
              return LayoutController(
                  desktopBody: DesktopLayout(state.userModel),
                  mobileBody: MobileLayout(state.userModel),
                  );
            }
            return Container();
          }),
    );
  }
}
