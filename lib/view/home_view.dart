import 'package:flutter/material.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/view/project/projects_by_user_view.dart';
import 'package:work_flow_manager/view/project/projects_view.dart';

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
  static final List<Widget> _widgetOptions = <Widget>[
    ProjectsView(),
    ProjectsByUserView()
  ];

  static final List<Menu> menus = [
    const Menu(
      title: 'Proyectos',
      icon: Icons.list,
      index: 0,
    ),
    const Menu(
      title: 'Mis Proyectos',
      icon: Icons.art_track,
      index: 1,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getTitle() {
    String title = '';
    switch (_selectedIndex) {
      case 0:
        title = 'Proyectos';
        break;
      case 1:
        title = 'Mis Proyectos';
        break;
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.appColor,
        title: Text(_getTitle()),
      ),
      body: _widgetOptions[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.appColor,
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.person_2_rounded,
                      size: 100,
                      color: Colors.white,
                    ),
                    Text(
                      'User Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ...menus
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
                          style: const TextStyle(color: AppTheme.darkText),
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
            SizedBox(height: MediaQuery.of(context).size.height / 1.9),
            Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: AppTheme.darkText,
                ),
                title: Text(
                  'Cerrar sesión',
                  style: const TextStyle(color: AppTheme.darkText),
                ),
                selected: _selectedIndex == 0,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(0);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
