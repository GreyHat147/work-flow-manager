import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/view/widgets/widgets.dart';

List<String> members = [
  'Juan Perez',
  'Jorge Osorio',
  'Maria Camila',
  'Sam Perez',
];

List<String> tasks = [
  'Crear base de datos',
  'Crear API',
  'Crear UI',
  'Crear',
];

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
  const DetailProjectView({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.nearlyDarkBlue,
        title: const Text(
          'Nombre del Proyecto',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*  Chip(
                label: Text('Nuevo Desarrollo'),
              ), */
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
                      ...members
                          .map(
                            (e) => Column(
                              children: [
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  title: Text(e),
                                  trailing: FittedBox(
                                    child: Row(
                                      children: [
                                        const Text('8hrs'),
                                        const SizedBox(width: 10),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.close),
                                        )
                                      ],
                                    ),
                                  ),
                                  leading: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.person),
                                  ),
                                ),
                                const Divider(height: 2),
                              ],
                            ),
                          )
                          .toList(),
                      const SizedBox(height: 30),
                      CustomButton(
                        child: const Text("Agregar Miembro"),
                        onPressed: () {},
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
                      ...tasks
                          .map(
                            (e) => Column(
                              children: [
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  title: Text(e),
                                  subtitle: const Text('Juan Perez'),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.close),
                                  ),
                                  leading: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.task),
                                  ),
                                ),
                                const Divider(height: 2),
                              ],
                            ),
                          )
                          .toList(),
                      const SizedBox(height: 30),
                      CustomButton(
                        child: const Text("Crear Tarea"),
                        onPressed: () {},
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
      ),
    );
  }
}
