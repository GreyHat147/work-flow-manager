import 'package:flutter/material.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/view/widgets/custom_text_field.dart';

class TaskItem {
  const TaskItem({
    required this.name,
    required this.assignedTo,
  });

  final String name;
  final String assignedTo;
}

List<TaskItem> tasks = const [
  TaskItem(
    name: 'Tarea 1',
    assignedTo: 'Juan Perez',
  ),
  TaskItem(
    name: 'Tarea 2',
    assignedTo: 'Jorge Osorio',
  ),
  TaskItem(
    name: 'Tarea 3',
    assignedTo: 'Maria Camila',
  ),
  TaskItem(
    name: 'Tarea 4',
    assignedTo: 'Sam Perez',
  ),
];

class TasksView extends StatelessWidget {
  TasksView({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.nearlyDarkBlue,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: CustomTextField(
              labelText: "Buscar Tarea",
              controller: searchController,
              keyboardType: TextInputType.text,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.task),
                  title: Text(tasks[index].name),
                  subtitle: Text("Asignado a: ${tasks[index].assignedTo}"),
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
