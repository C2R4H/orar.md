import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../midend/bloc/select_bloc/select_bloc.dart';
import '../../../midend/bloc/orar_bloc/orar_bloc.dart';
import '../../../midend/user_model.dart';

import '../widgets/drawer_widget.dart';
import '../screens/orar_screen.dart';


class DesktopLayout extends StatefulWidget{
  final UserModel userModel;
  DesktopLayout(this.userModel);

  @override
  _DesktopLayoutState createState()=> _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout>{

  final SelectBloc _selectBloc = SelectBloc();
  final OrarBloc _orarBloc = OrarBloc();

  @override
  void dispose(){
    _selectBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _orarBloc.add(GetOrarData(widget.userModel));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff121212),
        centerTitle: false,
        title: const Image(
          image: AssetImage('assets/orarpng.png'),
          height: 25,
        ),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 350,
            // TODO: make this configurable
            child: BlocProvider(
              create: (_) => _selectBloc,
              child: drawerWidget(context, _selectBloc),
            ),
          ),
          // vertical black line as separator
          Container(width: 0.5, color: Colors.black),
          // use Expanded to take up the remaining horizontal space
          Expanded(
            // TODO: make this configurable
            child: BlocBuilder<OrarBloc, OrarState>(
              bloc: _orarBloc,
              builder: (context, state) {
                if (state is OrarStateLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (state is OrarStateLoadedData) {
                  return orar_screen(state.orar);
                }
                if (state is OrarStateError) {
                  return const Center(
                    child: Text('There was an error, please refresh'),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
