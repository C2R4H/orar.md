import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screen_controller.dart';

import '../../../midend/bloc/select_bloc/select_bloc.dart';
import '../../../midend/user_model.dart';

import '../../../backend/database/auth_database.dart';

class newUser_screen extends StatefulWidget {
  @override
  newUser_screen_state createState() => newUser_screen_state();
}

    //TODO REWORK NEW USER SCREEN 

class newUser_screen_state extends State<newUser_screen> {

  SelectBloc _selectBloc = SelectBloc();
  AuthMethods _authMethods = AuthMethods();
  UserModel userModel =  UserModel();

  @override
  void initState() {
    _selectBloc.add(LoadColegii('colegii'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: BlocProvider(
            create: (context) => _selectBloc,
            child: BlocListener<SelectBloc, SelectState>(
              listener: (context, state) {
                if (state is SelectStateChoosedGroup) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => screen_controller()),
                  );
                }
              },
              child: BlocBuilder<SelectBloc, SelectState>(
                bloc: _selectBloc,
                builder: (context, state) {
                  print(state);
                  if (state is SelectStateLoading) {
                    return Center(child: CircularProgressIndicator.adaptive());
                  }
                  if (state is SelectStateColegiiLoaded) {
                    return chooseWidget(context, state.colegiuModelList, true);
                  }
                  if (state is SelectStateChoosedColegiu) {
                    return chooseWidget(context, state.colegiuModel, false);
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget chooseWidget(context, colegiuModel, bool selectGrupa) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            selectGrupa ? 'Salut,' : 'urmatorul pas,',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            selectGrupa ? 'alegeti institutia de invatamant' : 'alegeti grupa dumneavoastra',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 30,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Spacer(),
        ListView.builder(
          shrinkWrap: true,
          itemCount: selectGrupa
              ? colegiuModel.length
              : colegiuModel.listaGrupeName.length,
          itemBuilder: (context, index) {
            return Card(
                color: Color(0xff121212),
                margin: EdgeInsets.all(0),
                shape: Border.symmetric(
                    horizontal: BorderSide(
                  color: Color(0xff313131),
                ),
                ),
              child: ListTile(
              title: selectGrupa
                  ? Text('${colegiuModel[index].colegiuName}',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/20,
                          ),
                      )
                  : Text('${colegiuModel.listaGrupeName[index]}'),
              onTap: () async {
                if (selectGrupa) {
                  _selectBloc.add(LoadGroups(colegiuModel[index]));
                } else {
                  await _authMethods.createAnonymousAccount();
                  _selectBloc.add(LoadOrar(colegiuModel.listaGrupeName[index],
                      colegiuModel.colegiuID));
                }
              },
            ),
            );
          },
        ),
        Spacer(),
      ],
    );
  }
}
