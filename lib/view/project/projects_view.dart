import 'package:flutter/material.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/view/widgets/custom_text_field.dart';

class Project {
  const Project({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.members,
  });

  final String name;
  final String startDate;
  final String endDate;
  final String type;
  final List<String> members;
}

List<Project> projects = const [
  Project(
    name: 'Proyecto 1',
    startDate: '01/01/2021',
    endDate: '01/01/2022',
    type: 'Nuevo Desarrollo',
    members: [
      'Juan Perez - Desarollador',
      'Jorge Osorio - Tech Manager',
      'Maria Camila - Product Desinger',
      'Sam Perez - Product Owner',
    ],
  ),
  Project(
    name: 'Proyecto 2',
    startDate: '01/01/2021',
    endDate: '01/01/2022',
    type: 'Mantenimiento',
    members: [
      'Juan Perez - Desarollador',
      'Jorge Osorio - Tech Manager',
      'Maria Camila - Product Desinger',
      'Sam Perez - Product Owner',
    ],
  ),
  Project(
    name: 'Proyecto 3',
    startDate: '01/01/2021',
    endDate: '01/01/2022',
    type: 'Nuevo Desarrollo',
    members: [
      'Juan Perez - Desarollador',
      'Jorge Osorio - Tech Manager',
      'Maria Camila - Product Desinger',
      'Sam Perez - Product Owner',
    ],
  ),
  Project(
    name: 'Proyecto 4',
    startDate: '01/01/2021',
    endDate: '01/01/2022',
    type: 'Mantenimiento',
    members: [
      'Juan Perez - Desarollador',
      'Jorge Osorio - Tech Manager',
      'Maria Camila - Product Desinger',
      'Sam Perez - Product Owner',
    ],
  ),
  Project(
    name: 'Proyecto 5',
    startDate: '01/01/2021',
    endDate: '01/01/2022',
    type: 'Nuevo Desarrollo',
    members: [
      'Juan Perez - Desarollador',
      'Jorge Osorio - Tech Manager',
      'Maria Camila - Product Desinger',
      'Sam Perez - Product Owner',
    ],
  ),
];

class ProjectsView extends StatelessWidget {
  ProjectsView({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.nearlyDarkBlue,
        title: const Text(
          'Proyectos',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: CustomTextField(
              labelText: "Buscar Proyecto",
              controller: searchController,
              keyboardType: TextInputType.text,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(projects[index].name),
                  subtitle: Text(projects[index].type),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                );
              },
              separatorBuilder: (context, index) => const Divider(
                height: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
