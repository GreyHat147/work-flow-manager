import 'package:flutter/material.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/view/project/projects_view.dart';
import 'package:work_flow_manager/view/record/records_view.dart';
import 'package:work_flow_manager/view/task/tasks_view.dart';

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
    TasksView(),
    RecordsView(),
  ];

  static final List<Menu> menus = [
    const Menu(
      title: 'Proyectos',
      icon: Icons.list,
      index: 0,
    ),
    const Menu(
      title: 'Tareas',
      icon: Icons.list,
      index: 1,
    ),
    const Menu(
      title: 'Registros',
      icon: Icons.line_style,
      index: 2,
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
        title = 'Tareas';
        break;
      case 2:
        title = 'Registros';
        break;
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.nearlyDarkBlue,
        title: Text(_getTitle()),
      ),
      body: _widgetOptions[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.nearlyDarkBlue,
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
          ],
        ),
      ),
    );
  }
}