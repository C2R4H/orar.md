import 'package:flutter/material.dart';
import '../screen_controller.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../midend/bloc/select_bloc/select_bloc.dart';
import '../../backend/database/auth_database.dart';

Widget drawerWidget(context, _selectBloc) {
  AuthMethods authMethods = AuthMethods(); //REMOVE AFTER TESTING

  double width = MediaQuery.of(context).size.width;

  bool menu = true;

  Widget colegiuGrupaChoose() {
    return BlocBuilder<SelectBloc, SelectState>(builder: (context, state) {
      if (state is SelectStateLoading) {
        return const CircularProgressIndicator.adaptive();
      }
      if (state is SelectStateColegiiLoaded) {
        return ListView(
          children: [
            Container(
              alignment: Alignment.center,
              color: Colors.black,
              height: MediaQuery.of(context).size.height / 6,
              child: Text(
                'Grupe',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height / 30,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await authMethods.logout();
              },
              child: Text('log out'),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: state.colegiuModelList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.colegiuModelList[index].colegiuName),
                  onTap: () {
                    _selectBloc.add(LoadGroups(state.colegiuModelList[index]));
                  },
                );
              },
            ),
          ],
        );
      }
      if (state is SelectStateChoosedColegiu) {
        return ListView(
          children: [
            Container(
              alignment: Alignment.center,
              color: Colors.black,
              height: MediaQuery.of(context).size.height / 6,
              child: Text(
                'Grupe',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height / 30,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: state.colegiuModel.listaGrupeName.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.colegiuModel.listaGrupeName[index]),
                  onTap: () {
                    _selectBloc.add(LoadOrar(
                        state.colegiuModel.listaGrupeName[index],
                        state.colegiuModel.colegiuID));
                  },
                );
              },
            ),
          ],
        );
      }
      return ListView(
        children: [],
      );
    });
  }

  return Drawer(
    backgroundColor: const Color(0xff212121).withOpacity(0.96),
    child: BlocListener<SelectBloc, SelectState>(
      listener: (context, state) {
        if (state is SelectStateChoosedGroup) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => screen_controller()),
              (Route<dynamic> route) => false);
        }
      },
      child: BlocBuilder<SelectBloc, SelectState>(builder: (context, state) {
        if (state is SelectStateLoading) {
          return const CircularProgressIndicator.adaptive();
        }
        if (state is SelectStateColegiiLoaded) {
          return ListView(
            children: [
              Container(
                alignment: Alignment.center,
                color: Color(0xff121212),
                height: MediaQuery.of(context).size.height / 6,
                child: Text(
                  'Instituții ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height / 30,
                  ),
                ),
              ),
              /* TextButton(
                onPressed: () async {
                  await authMethods.logout();
                },
                child: Text('log out'),
              ),*/
              ListView.builder(
                shrinkWrap: true,
                itemCount: state.colegiuModelList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(state.colegiuModelList[index].colegiuName),
                        onTap: () {
                          _selectBloc
                              .add(LoadGroups(state.colegiuModelList[index]));
                        },
                      ),
                      Divider(
                        indent: 0,
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        }
        if (state is SelectStateChoosedColegiu) {
          return ListView(
            children: [
              Container(
                alignment: Alignment.center,
                color: Color(0xff121212),
                height: MediaQuery.of(context).size.height / 6,
                child: Text(
                  'Grupe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height / 30,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: state.colegiuModel.listaGrupeName.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.colegiuModel.listaGrupeName[index]),
                    onTap: () {
                      _selectBloc.add(LoadOrar(
                          state.colegiuModel.listaGrupeName[index],
                          state.colegiuModel.colegiuID));
                    },
                  );
                },
              ),
            ],
          );
        }
        return ListView(
          children: [
            Container(
              color: Color(0xff121212),
              alignment: Alignment.centerLeft,
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'V0.9 pre-aplha',
                        style: TextStyle(
                          color: Color(0xff515151),
                          fontSize: width / 30,
                        ),
                      ),
                      Text(
                        'Made by UserApps',
                        style: TextStyle(
                          color: Color(0xff515151),
                          fontSize: width / 30,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Image(
                      image: AssetImage('assets/orarpng.png'),
                      height: MediaQuery.of(context).size.width / 15,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      authMethods.auth.currentUser!.uid,
                      style: TextStyle(
                        color: Color(0xff212121),
                        fontSize: width / 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 2,
              color: Color(0xff313131),
              width: width,
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: width / 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instituții de învățământ',
                    style: TextStyle(
                      color: Color(0xffA1A1A1),
                      fontSize: width / 25,
                    ),
                  ),
                  Column(
                    children: [
                      ListTile(
                        enabled: false,
                        onTap: () async {
                          //await _selectBloc.add(LoadColegii('universitate'));
                        },
                        title: Text(
                          'Universitate',
                          style: TextStyle(
                            fontSize: width / 20,
                          ),
                        ),
                        minLeadingWidth: 15,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        leading: Icon(Icons.school),
                      ),
                      ListTile(
                        onTap: () async {
                          await _selectBloc.add(LoadColegii('colegii'));
                        },
                        title: Text(
                          'Colegiu',
                          style: TextStyle(
                            fontSize: width / 20,
                          ),
                        ),
                        minLeadingWidth: 15,
                        minVerticalPadding: 10,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        leading: Icon(Icons.school),
                      ),
                      ListTile(
                        onTap: () async {
                          await _selectBloc.add(LoadColegii('scoala'));
                        },
                        title: Text(
                          'Școală',
                          style: TextStyle(
                            fontSize: width / 20,
                          ),
                        ),
                        minLeadingWidth: 15,
                        minVerticalPadding: 10,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        leading: Icon(Icons.school),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: width / 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Altele',
                    style: TextStyle(
                      color: Color(0xffA1A1A1),
                      fontSize: width / 25,
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        ListTile(
                        enabled: false,
                          onTap: () {},
                          title: Text(
                            'Setări',
                            style: TextStyle(
                              fontSize: width / 20,
                            ),
                          ),
                          minLeadingWidth: 15,
                          minVerticalPadding: 10,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          leading: Icon(Icons.settings),
                        ),
                        ListTile(
                        enabled: false,
                          onTap: () {},
                          title: Text(
                            'Informații',
                            style: TextStyle(
                              fontSize: width / 20,
                            ),
                          ),
                          minLeadingWidth: 15,
                          minVerticalPadding: 10,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          leading: Icon(Icons.info_outlined),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    ),
  );
}
