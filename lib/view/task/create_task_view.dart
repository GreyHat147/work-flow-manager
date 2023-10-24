import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/view/widgets/widgets.dart';

class CreateTaskView extends StatelessWidget {
  CreateTaskView({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.nearlyDarkBlue,
        title: const Text(
          'Crear tarea',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
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
                  labelText: 'Descripción',
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.description),
                  maxLines: null,
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
                DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      controller: TextEditingController(),
                      cursorColor: Colors.blue,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Busca un miembro",
                        hintStyle: TextStyle(color: Colors.blue),
                      ),
                    ),
                    showSelectedItems: true,
                    disabledItemFn: (String s) => s.startsWith('I'),
                  ),
                  items: const [
                    "Brazil",
                    "Italia (Disabled)",
                    "Tunisia",
                    'Canada'
                  ],
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Selecciona un miembro",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                  onChanged: print,
                  selectedItem: "Brazil",
                ),
                const SizedBox(height: 80),
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
