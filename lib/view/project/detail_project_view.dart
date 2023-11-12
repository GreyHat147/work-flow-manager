import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/injections.dart';
import 'package:work_flow_manager/models/project_model.dart';
import 'package:work_flow_manager/repository/projects/projects_repository.dart';
import 'package:work_flow_manager/repository/projects/projects_state.dart';
import 'package:work_flow_manager/view/member/create_member_view.dart';
import 'package:work_flow_manager/view/task/create_task_view.dart';
import 'package:work_flow_manager/view/widgets/widgets.dart';

class WorkedHoursData {
  WorkedHoursData(this.month, this.hours);

  final DateTime month;
  final double hours;
}

List<WorkedHoursData> data = [
  WorkedHoursData(DateTime(2023, 6, 1), 10),
  WorkedHoursData(DateTime(2023, 7, 1), 28),
  WorkedHoursData(DateTime(2023, 8, 1), 34),
  WorkedHoursData(DateTime(2023, 9, 1), 8),
  WorkedHoursData(DateTime(2023, 10, 1), 40)
];

class DetailProjectView extends StatefulWidget {
  const DetailProjectView({super.key, required this.id});

  final String id;

  @override
  State<DetailProjectView> createState() => _DetailProjectViewState();
}

class _DetailProjectViewState extends State<DetailProjectView>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  Widget _body(ProjectModel project, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Text(
              "Equipo",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Miembros",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          "Horas Trabajadas",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    project.members.isNotEmpty
                        ? Column(
                            children: project.members
                                .map(
                                  (e) => Column(
                                    children: [
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5),
                                        title: Text(e.name),
                                        trailing: FittedBox(
                                          child: Row(
                                            children: [
                                              Text(e.workedHours.toString()),
                                              const SizedBox(width: 10),
                                              IconButton(
                                                onPressed: () {
                                                  context
                                                      .read<
                                                          ProjectsRepository>()
                                                      .removeMemberByProject(
                                                        e.id!,
                                                        project,
                                                      );
                                                },
                                                icon: const Icon(Icons.close),
                                              )
                                            ],
                                          ),
                                        ),
                                        leading: const Icon(Icons.person),
                                      ),
                                      const Divider(height: 2),
                                    ],
                                  ),
                                )
                                .toList(),
                          )
                        : const Center(child: Text("No hay miembros")),
                    const SizedBox(height: 30),
                    CustomButton(
                      child: const Text("Agregar Miembro"),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateMemberView(
                              projectId: project.id,
                            ),
                          ),
                        ).then(
                          (value) => context
                              .read<ProjectsRepository>()
                              .getProject(project.id!),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Tareas",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    project.tasks.isNotEmpty
                        ? Column(
                            children: project.tasks
                                .map(
                                  (e) => Column(
                                    children: [
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 2),
                                        title: Text(e.name),
                                        subtitle: Text(e.assignedMember),
                                        trailing: IconButton(
                                          onPressed: () {
                                            context
                                                .read<ProjectsRepository>()
                                                .removeTaskByProject(
                                                  e.id!,
                                                  project,
                                                );
                                          },
                                          icon: const Icon(Icons.close),
                                        ),
                                        leading: const Icon(Icons.task),
                                      ),
                                      const Divider(height: 2),
                                    ],
                                  ),
                                )
                                .toList(),
                          )
                        : const Center(child: Text("No hay tareas")),
                    const SizedBox(height: 30),
                    CustomButton(
                      child: const Text("Crear Tarea"),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return CreateTaskView(projectId: project.id!);
                          }),
                        ).then((_) => context
                            .read<ProjectsRepository>()
                            .getProject(project.id!));
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Rendiemiento General",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(),
                  series: <ChartSeries>[
                    // Renders line chart
                    LineSeries<WorkedHoursData, DateTime>(
                      dataSource: data,
                      xValueMapper: (WorkedHoursData workedHoursData, _) =>
                          workedHoursData.month,
                      yValueMapper: (WorkedHoursData workedHoursData, _) =>
                          workedHoursData.hours,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _deleteProyect(String proyectId, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar Proyecto"),
        content: const Text("¿Está seguro que desea eliminar el proyecto?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<ProjectsRepository>().deleteProject(proyectId);
              Navigator.pop(context);
            },
            child: const Text(
              "Eliminar",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext _) {
    return BlocProvider(
      create: (context) => getIt<ProjectsRepository>()..getProject(widget.id),
      child: BlocConsumer<ProjectsRepository, ProjectsState>(
        listener: (context, state) {
          if (state is ProjectDeletedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Proyecto eliminado exitosamente'),
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, ProjectsState state) {
          Widget body = const Center(
            child: Text('Proyecto no encontrado'),
          );

          if (state is ProjectsLoadingState) {
            body = const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProjectDetailsState) {
            body = _body(state.projectSelected, context);
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppTheme.appColor,
              title: const Text('Detalles del Proyecto'),
              actions: [
                IconButton(
                  onPressed: () => _deleteProyect(widget.id, context),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            body: body,
          );
        },
      ),
    );
  }
}
