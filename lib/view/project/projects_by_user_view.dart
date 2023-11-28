import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_flow_manager/injections.dart';
import 'package:work_flow_manager/models/task_model.dart';
import 'package:work_flow_manager/repository/projects/projects_repository.dart';
import 'package:work_flow_manager/repository/projects/projects_state.dart';
import 'package:work_flow_manager/view/task/tasks_view.dart';
import 'package:work_flow_manager/view/widgets/custom_text_field.dart';

class ProjectsByUserView extends StatelessWidget {
  ProjectsByUserView({super.key});

  final TextEditingController searchController = TextEditingController();

  List<TaskModel> getMyTasks(List<TaskModel> tasks, BuildContext context) {
    String? userId = context.read<ProjectsRepository>().getUserId();
    if (userId == null) return [];

    return tasks.where((element) => element.assignedMember == userId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProjectsRepository>()..getProjectsByUser(),
      child: BlocBuilder<ProjectsRepository, ProjectsState>(
        builder: (context, state) {
          if (state is ProjectsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProjectsByUser) {
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: CustomTextField(
                    labelText: "Buscar Proyecto",
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                state.projects.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          itemCount: state.projects.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              title: Text(state.projects[index].name),
                              subtitle: Text(state.projects[index].projectType),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return TasksView(
                                        projectId: state.projects[index].id!,
                                        tasks: getMyTasks(
                                          state.projects[index].tasks,
                                          context,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const Divider(height: 2),
                        ),
                      )
                    : const Center(
                        child: Text("No tienes ningún proyecto asignado")),
              ],
            );
          } else {
            return const Center(
                child: Text("No tienes ningún proyecto asignado"));
          }
        },
      ),
    );
  }
}
