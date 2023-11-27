import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/injections.dart';
import 'package:work_flow_manager/repository/auth/auth_respository.dart';
import 'package:work_flow_manager/view/project/projects_by_user_view.dart';
import 'package:work_flow_manager/view/project/projects_view.dart';
import 'package:work_flow_manager/view/reports/reports_view.dart';

class Menu {
  const Menu({
    required this.title,
    required this.icon,
    required this.index,
  });

  final String title;
  final IconData icon;
  final int index;
}

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.title});

  final String title;

  @override
  State<HomeView> createState() => _HomeViewPageState();
}

class _HomeViewPageState extends State<HomeView> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptionsManager = <Widget>[
    ProjectsView(),
    const ReportsView()
  ];

  static final List<Widget> _widgetOptionsEmployee = <Widget>[
    ProjectsByUserView()
  ];

  static final List<Menu> menusManager = [
    const Menu(
      title: 'Proyectos',
      icon: Icons.list,
      index: 0,
    ),
    const Menu(title: 'Reportes', icon: Icons.file_copy, index: 1),
  ];

  static final List<Menu> menusEmployee = [
    const Menu(
      title: 'Mis Proyectos',
      icon: Icons.art_track,
      index: 0,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getTitleByMenu(AuthState state) {
    String title = '';
    if (state is AuthLoaded) {
      if (state.role == "Gerente") {
        switch (_selectedIndex) {
          case 0:
            title = 'Proyectos';
            break;
          case 1:
            title = 'Reportes';
            break;
        }
      } else {
        switch (_selectedIndex) {
          case 0:
            title = 'Mis Proyectos';
            break;
        }
      }
    }

    return title;
  }

  List<Menu> getMenu(String role) {
    if (role == 'Gerente') {
      return menusManager;
    } else {
      return menusEmployee;
    }
  }

  Widget _getBody(AuthState state) {
    if (state is AuthLoaded) {
      if (state.role == "Gerente") {
        return _widgetOptionsManager.elementAt(_selectedIndex);
      } else {
        return _widgetOptionsEmployee.elementAt(_selectedIndex);
      }
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthRepository>()..checkLogin(),
      child: BlocConsumer<AuthRepository, AuthState>(
        listener: (context, state) {
          if (state is AuthLoaded && state.loggedOut) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            appBar: AppBar(
              backgroundColor: AppTheme.appColor,
              title: Text(_getTitleByMenu(state)),
            ),
            body: _getBody(state),
            drawer: Drawer(
              child: state is AuthLoaded
                  ? ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        DrawerHeader(
                          decoration: const BoxDecoration(
                            color: AppTheme.appColor,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 100,
                                  color: Colors.white,
                                ),
                                Text(
                                  state.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ...getMenu(state.role)
                            .map(
                              (menu) => Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      menu.icon,
                                      color: AppTheme.darkText,
                                    ),
                                    title: Text(
                                      menu.title,
                                      style: const TextStyle(
                                          color: AppTheme.darkText),
                                    ),
                                    selected: _selectedIndex == 0,
                                    onTap: () {
                                      // Update the state of the app
                                      _onItemTapped(menu.index);
                                      // Then close the drawer
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const Divider(
                                    height: 2,
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 1.9),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ListTile(
                            leading: const Icon(
                              Icons.logout,
                              color: AppTheme.darkText,
                            ),
                            title: const Text(
                              'Cerrar sesión',
                              style: TextStyle(color: AppTheme.darkText),
                            ),
                            selected: _selectedIndex == 0,
                            onTap: () {
                              Navigator.pop(context);
                              context.read<AuthRepository>().logout();
                            },
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ),
          );
        },
      ),
    );
  }
}
