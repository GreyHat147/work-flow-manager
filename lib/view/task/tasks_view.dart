import 'package:flutter/material.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/models/task_model.dart';
import 'package:work_flow_manager/view/record/records_view.dart';
import 'package:work_flow_manager/view/widgets/custom_text_field.dart';

class TasksView extends StatelessWidget {
  TasksView({
    super.key,
    required this.projectId,
    required this.tasks,
  });

  final String projectId;
  final List<TaskModel> tasks;

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appColor,
        title: const Text("Mis Tareas"),
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
          tasks.isNotEmpty
              ? Expanded(
                  child: ListView.separated(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.task),
                        title: Text(tasks[index].name),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return RecordsView(
                                taskId: tasks[index].id!,
                                projectId: projectId,
                              );
                            },
                          ));
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      height: 2,
                    ),
                  ),
                )
              : const Center(
                  child: Text("No hay tareas asignadas"),
                )
        ],
      ),
    );
  }
}
