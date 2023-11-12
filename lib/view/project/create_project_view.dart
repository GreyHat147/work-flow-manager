import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/injections.dart';
import 'package:work_flow_manager/models/member_model.dart';
import 'package:work_flow_manager/models/project_model.dart';
import 'package:work_flow_manager/repository/projects/projects_repository.dart';
import 'package:work_flow_manager/repository/projects/projects_state.dart';
import 'package:work_flow_manager/view/widgets/widgets.dart';

List<String> proyectTypes = [
  'Nuevo Desarrollo',
  'Mantenimiento',
];

class CreateProjectView extends StatefulWidget {
  const CreateProjectView({super.key});

  @override
  State<CreateProjectView> createState() => _CreateProjectViewState();
}

class _CreateProjectViewState extends State<CreateProjectView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String proyectType = 'Nuevo Desarrollo';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  MemberModel? memberSelected;

  @override
  void initState() {
    super.initState();
  }

  void pickDate(TextEditingController field) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
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

  void _createMember(BuildContext context) {
    if (_formKey.currentState!.validate() && memberSelected != null) {
      String projectId =
          getIt<FirebaseFirestore>().collection("members").doc().id;
      memberSelected!.projects.add(projectId);
      ProjectModel project = ProjectModel(
        id: projectId,
        name: nameController.text,
        projectType: proyectType,
        startDate: DateTime.parse(startDateController.text),
        endDate: DateTime.parse(endDateController.text),
        members: [memberSelected!],
        createdAt: DateTime.now(),
      );
      context.read<ProjectsRepository>().addProject(project);
    }
  }

  Widget _form(ProjectsLoadedState state, BuildContext context) {
    return Form(
      key: _formKey,
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
            onTap: () => pickDate(startDateController),
          ),
          const SizedBox(height: 40),
          CustomTextField(
            labelText: 'Fecha de fin',
            controller: endDateController,
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(Icons.calendar_month),
            onTap: () => pickDate(endDateController),
          ),
          const SizedBox(height: 40),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.calendar_month),
              labelText: 'Tipo de proyecto',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: AppTheme.appColor),
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
          Row(
            children: [
              Flexible(
                child: DropdownSearch<String>(
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
                  items: state.members.map((e) => e.name).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un valor';
                    }
                    return null;
                  },
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
                  onChanged: (String? newValue) {
                    setState(() {
                      memberSelected = state.members.firstWhere(
                        (element) => element.name == newValue,
                      );
                    });
                  },
                  //selectedItem: state.members.first.name,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addMember').then(
                (_) => context.read<ProjectsRepository>().getMembers(),
              );
            },
            child: const Text("Crear Miembro"),
          ),
          const SizedBox(height: 40),
          CustomButton(
            onPressed: () => _createMember(context),
            child: const Text(
              'Crear',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    nameController.text = "";
    startDateController.text = "";
    endDateController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProjectsRepository>()..getMembers(),
      child: BlocConsumer<ProjectsRepository, ProjectsState>(
        listener: (context, state) {
          if (state is ProjectsLoadedState && state.wasProjectCreated) {
            _resetForm();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Proyecto creado exitosamente'),
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, ProjectsState state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppTheme.appColor,
              title: const Text(
                'Crear proyecto',
                style: TextStyle(fontSize: 18),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Builder(
                  builder: (BuildContext context) {
                    if (state is ProjectsLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is ProjectsLoadedState) {
                      return _form(state, context);
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
