import 'package:flutter/material.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/view/widgets/widgets.dart';

List<String> proyectTypes = [
  'Nuevo Desarrollo',
  'Mantenimiento',
];

/* List<Map<String, dynamic>> members = [
  {'name': 'Juan Perez', 'type': 'Desarollador'},
  {'name': 'Jorge Osorio', 'type': 'Tech Manager'},
  {'name': 'Maria Camila', 'type': 'Product Desinger'},
  {'name': 'Sam Perez', 'type': 'Product Owner'},
]; */

List<String> members = [
  'Juan Perez - Desarollador',
  'Jorge Osorio - Tech Manager',
  'Maria Camila - Product Desinger',
  'Sam Perez - Product Owner',
];

class CreateProjectView extends StatefulWidget {
  const CreateProjectView({super.key});

  @override
  State<CreateProjectView> createState() => _CreateProjectViewState();
}

class _CreateProjectViewState extends State<CreateProjectView> {
  String proyectType = 'Nuevo Desarrollo';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController searchMemberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.nearlyDarkBlue,
        title: const Text(
          'Crear proyecto',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                CustomTextField(
                  labelText: 'Nombre del proyecto',
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.label),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  labelText: 'Fecha de inicio',
                  controller: startDateController,
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.calendar_month),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  labelText: 'Fecha de fin',
                  controller: endDateController,
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.calendar_month),
                ),
                const SizedBox(height: 40),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month),
                    labelText: 'Tipo de proyecto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: AppTheme.nearlyDarkBlue),
                    ),
                  ),
                  value: proyectType,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: proyectTypes.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      proyectType = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  labelText: 'Agregar Miembro',
                  controller: searchMemberController,
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.search),
                  enabled: false,
                ),
                const SizedBox(height: 20),
                ...members
                    .map(
                      (member) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(member),
                                ),
                                const SizedBox(width: 15),
                                IconButton(
                                  alignment: Alignment.centerRight,
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                const Divider(),
                const SizedBox(height: 40),
                CustomButton(
                  child: const Text(
                    'Crear',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    print('Creando Proyecto');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
