import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/view/widgets/widgets.dart';

class CreateRecordView extends StatelessWidget {
  CreateRecordView({super.key});

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
          'Crear registro',
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
                  labelText: 'Nombre',
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
