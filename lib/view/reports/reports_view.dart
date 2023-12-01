import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/injections.dart';
import 'package:work_flow_manager/models/project_model.dart';
import 'package:work_flow_manager/repository/reports/reports_repository.dart';
import 'package:work_flow_manager/view/widgets/custom_text_field.dart';

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

  List<ReportType> reportTypes = [
    const ReportType('Miembros', 'membersByProject'),
    const ReportType('Horas por miembro', 'hoursByMember'),
    const ReportType('Tareas por miembro', 'tasksByMember'),
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
        return _drawHoursMemberByProject(state.hoursByMemberOfProject);
      case 'tasksByMember':
        return _drawTasksMemberByProject(state.tasksByMemberOfProject);
      case 'membersByProject':
        return _drawMembersByProject(state.membersByProject);
      default:
        return const Center(
          child: Text('No se ha seleccionado un tipo de reporte'),
        );
    }
  }

  Color getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
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

  Widget _drawTasksMemberByProject(List<Map<String, dynamic>> data) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(minimum: 0, interval: 1),
      series: <ChartSeries>[
        BarSeries<Map<String, dynamic>, String>(
          dataSource: data,
          xValueMapper: (Map<String, dynamic> data, _) => data['name'],
          yValueMapper: (Map<String, dynamic> data, _) => data['tasks'],
          name: 'Gold',
          color: Colors.cyan,
        ),
      ],
    );
  }

  void _getReport(BuildContext context) {
    if (projectSelected == null || reportTypeSelected == null) return;

    switch (reportTypeSelected!.value) {
      case 'hoursByMember':
        context
            .read<ReportsRepository>()
            .getHoursByMemberOfProject(projectSelected!.id!);
        break;

      case 'tasksByMember':
        context
            .read<ReportsRepository>()
            .getTasksByMember(projectSelected!.id!);
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
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
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
                      });
                    },
                    //selectedItem: state.members.first.name,
                  ),
                  const SizedBox(height: 30),
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
                    onTap: () => pickDate(endDateController),
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
                      _getReport(context);
                    },
                  ),
                  const SizedBox(height: 50),
                  _drawChart(state),
                ],
              ),
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
