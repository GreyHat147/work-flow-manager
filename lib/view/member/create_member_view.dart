import 'package:flutter/material.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/view/widgets/widgets.dart';

List<String> memberTypes = [
  'Developer',
  'Tech Manager',
  'Desinger',
  'Product Owner',
  'Scrum Master',
];

class CreateMemberView extends StatefulWidget {
  const CreateMemberView({super.key});

  @override
  State<CreateMemberView> createState() => _CreateMemberViewState();
}

class _CreateMemberViewState extends State<CreateMemberView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String memberType = 'Developer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.nearlyDarkBlue,
        title: const Text(
          'Crear miembro',
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
                  labelText: 'Nombre del miembro',
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.label),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  labelText: 'Correo electrónico',
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(height: 40),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.list_alt),
                    labelText: 'Seleccione el tipo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: AppTheme.nearlyDarkBlue),
                    ),
                  ),
                  value: memberType,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: memberTypes.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      memberType = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 100),
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
