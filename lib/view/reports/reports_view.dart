import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/injections.dart';
import 'package:work_flow_manager/models/member_model.dart';
import 'package:work_flow_manager/models/project_model.dart';
import 'package:work_flow_manager/models/task_model.dart';
import 'package:work_flow_manager/repository/reports/reports_repository.dart';
import 'package:work_flow_manager/view/widgets/widgets.dart';

class ReportType {
  const ReportType(this.name, this.value);

  final String name;
  final String value;
}

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  ProjectModel? projectSelected;
  MemberModel? memberSelected;
  TaskModel? taskSelected;

  List<ReportType> reportTypes = [
    const ReportType('Miembros', 'membersByProject'),
    const ReportType('Horas por miembros', 'hoursByMember'),
    const ReportType('Tareas por miembros', 'tasksByMember'),
    const ReportType('Hora por miembro en especifico', 'specificMember'),
    const ReportType('Tarea en especifico', 'specificTask'),
  ];

  ReportType? reportTypeSelected;

  Widget _drawChart(ReportsLoaded state) {
    if (reportTypeSelected == null) {
      return const Center(
        child: Text('Seleccione un tipo de reporte'),
      );
    }

    switch (reportTypeSelected!.value) {
      case 'hoursByMember':
      case 'specificMember':
        return _drawHoursMemberByProject(state.hoursByMemberOfProject);
      case 'tasksByMember':
        return _drawTasksMemberByProject(state.tasksByMemberOfProject);
      case 'membersByProject':
        return _drawMembersByProject(state.membersByProject);
      case 'specificTask':
        return _drawSpecificTaskByProject();
      default:
        return const Center(
          child: Text('No se ha seleccionado un tipo de reporte'),
        );
    }
  }

  Color getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  void _clearData() {
    setState(() {
      memberSelected = null;
      taskSelected = null;
    });
  }

  void pickDate(TextEditingController field) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          projectSelected != null ? projectSelected!.startDate : DateTime.now(),
      firstDate:
          projectSelected != null ? projectSelected!.startDate : DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.appColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.appColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      setState(() {
        field.text = formattedDate; //set output date to TextField value.
      });
    }
  }

  Widget _drawMembersByProject(List<Map<String, dynamic>> data) {
    final ProjectModel project = projectSelected!;
    return SfCircularChart(
      series: <CircularSeries>[
        // Render pie chart
        PieSeries<Map<String, dynamic>, String>(
          dataSource: data,
          pointColorMapper: (Map<String, dynamic> data, _) => getRandomColor(),
          xValueMapper: (Map<String, dynamic> data, _) => data['name'],
          yValueMapper: (Map<String, dynamic> data, _) => data['workedHours'],
          enableTooltip: true,
          explodeAll: true,
          dataLabelMapper: (datum, index) {
            return datum['name'];
          },
          sortFieldValueMapper: (datum, index) =>
              datum['workedHours'].toString(),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.inside,
            useSeriesColor: true,
          ),
        )
      ],
    );
  }

  Widget _drawHoursMemberByProject(List<Map<String, dynamic>> data) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        ColumnSeries<Map<String, dynamic>, String>(
          dataSource: data,
          xValueMapper: (Map<String, dynamic> data, _) => data['name'],
          yValueMapper: (Map<String, dynamic> data, _) => data['hours'],
          name: 'Gold',
          color: const Color.fromRGBO(8, 142, 255, 1),
        )
      ],
    );
  }

  Widget _drawSpecificTaskByProject() {
    if (taskSelected == null) return const SizedBox();
    final TaskModel task = taskSelected!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("Detalles de la tarea",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          title: Text(task.name),
          subtitle: const Text("Nombre de la tarea"),
          leading: const Icon(Icons.text_fields_outlined),
        ),
        ListTile(
          title: Text(task.description),
          subtitle: const Text("Descripción de la tarea"),
          leading: const Icon(Icons.description_outlined),
        ),
        ListTile(
          title: Text(DateFormat('yyyy-MM-dd').format(task.startDate)),
          subtitle: const Text("Fecha de Inicio"),
          leading: const Icon(Icons.calendar_today_outlined),
        ),
        ListTile(
          title: Text(DateFormat('yyyy-MM-dd').format(task.endDate)),
          subtitle: const Text("Fecha de Finalización"),
          leading: const Icon(Icons.calendar_month_outlined),
        ),
        ListTile(
          title: Text(task.assignedMemberName!),
          subtitle: const Text("Miembro asignado"),
          leading: const Icon(Icons.person_pin),
        ),
      ],
    );
  }

  Widget _drawTasksMemberByProject(List<Map<String, dynamic>> data) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(minimum: 0, interval: 1),
      series: <ChartSeries>[
        BarSeries<Map<String, dynamic>, String>(
          dataSource: data,
          xValueMapper: (Map<String, dynamic> data, _) => data['name'],
          yValueMapper: (Map<String, dynamic> data, _) => data['tasks'],
          color: Colors.cyan,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataLabelMapper: (Map<String, dynamic> data, index) =>
              data['workedHours'],
        ),
      ],
    );
  }

  void _getReport(BuildContext context, ReportsLoaded state) {
    if (projectSelected == null || reportTypeSelected == null) return;

    switch (reportTypeSelected!.value) {
      case 'hoursByMember':
        context
            .read<ReportsRepository>()
            .getHoursByMemberOfProject(projectSelected!.id!);
        break;

      case 'specificMember':
        context
            .read<ReportsRepository>()
            .getHoursByMemberOfProject(projectSelected!.id!, memberSelected);
        break;

      case 'specificTask':
        context.read<ReportsRepository>().getSpecificTask();
        break;

      case 'tasksByMember':
        context.read<ReportsRepository>().getTasksByMember(
              projectSelected!.id!,
              DateTime.parse(startDateController.text),
              DateTime.parse(endDateController.text),
            );
        break;

      case 'membersByProject':
        context
            .read<ReportsRepository>()
            .getMembersByProject(projectSelected!.id!);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ReportsRepository>()..getProjects(),
      child: BlocBuilder<ReportsRepository, ReportsState>(
        builder: (context, state) {
          if (state is ReportsInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ReportsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ReportsLoaded) {
            return ListView(
              padding: const EdgeInsets.all(30.0),
              children: [
                DropdownSearch<String>(
                  items: state.projects.map((e) => e.name).toList(),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      prefixIcon: const Icon(Icons.list),
                      labelText: "Seleccione un proyecto",
                      labelStyle: TextStyle(
                          fontFamily: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .fontFamily,
                          fontSize: 15),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    if (newValue == null) return;
                    setState(() {
                      projectSelected = state.projects.firstWhere(
                        (element) => element.name == newValue,
                      );
                      startDateController.text = DateFormat('yyyy-MM-dd')
                          .format(projectSelected!.startDate);
                    });
                  },
                  //selectedItem: state.members.first.name,
                ),
                const SizedBox(height: 30),
                DropdownSearch<String>(
                  enabled: projectSelected != null,
                  items: reportTypes.map((e) => e.name).toList(),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      prefixIcon: const Icon(Icons.list),
                      labelText: "Seleccione un tipo de reporte",
                      labelStyle: TextStyle(
                          fontFamily: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .fontFamily,
                          fontSize: 15),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    if (newValue == null) return;
                    setState(() {
                      reportTypeSelected = reportTypes.firstWhere(
                        (element) => element.name == newValue,
                      );
                    });

                    if (reportTypeSelected?.value == 'membersByProject' ||
                        reportTypeSelected?.value == 'hoursByMember') {
                      _getReport(context, state);
                    }

                    if (reportTypeSelected?.value == 'specificTask') {
                      taskSelected = null;
                    }
                  },
                ),
                const SizedBox(height: 30),
                projectSelected != null &&
                        reportTypeSelected?.value == 'specificMember'
                    ? DropdownSearch<String>(
                        items: projectSelected!.members
                            .map((e) => e.name)
                            .toList(),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            prefixIcon: const Icon(Icons.list),
                            labelText: "Seleccione un miembro",
                            labelStyle: TextStyle(
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontFamily,
                                fontSize: 15),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                        ),
                        onChanged: (String? newValue) {
                          if (newValue == null) return;
                          setState(() {
                            memberSelected = projectSelected!.members
                                .firstWhere(
                                    (element) => element.name == newValue);
                          });
                          _getReport(context, state);
                        },
                      )
                    : const SizedBox(),
                projectSelected != null &&
                        reportTypeSelected?.value == 'specificTask'
                    ? DropdownSearch<String>(
                        items:
                            projectSelected!.tasks.map((e) => e.name).toList(),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            prefixIcon: const Icon(Icons.list),
                            labelText: "Seleccione una tarea",
                            labelStyle: TextStyle(
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontFamily,
                                fontSize: 15),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                        ),
                        onChanged: (String? newValue) {
                          if (newValue == null) return;
                          setState(() {
                            taskSelected = projectSelected!.tasks.firstWhere(
                                (element) => element.name == newValue);
                          });
                          _getReport(context, state);
                        },
                      )
                    : const SizedBox(),
                Visibility(
                  visible: reportTypeSelected?.value == 'tasksByMember',
                  child: Column(
                    children: [
                      CustomTextField(
                        enabled: projectSelected != null,
                        labelText: 'Fecha de inicio',
                        controller: startDateController,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.calendar_month),
                        onTap: () => pickDate(startDateController),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        labelText: 'Fecha de fin',
                        controller: endDateController,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.calendar_month),
                        onTap: () {
                          pickDate(endDateController);
                        },
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        child: const Text('Generar Reporte'),
                        onPressed: () {
                          _getReport(context, state);
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                _drawChart(state),
                const SizedBox(height: 50),
              ],
            );
          } else {
            return const Center(
              child: Text('Error'),
            );
          }
        },
      ),
    );
  }
}
