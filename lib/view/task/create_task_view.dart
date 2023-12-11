import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/injections.dart';
import 'package:work_flow_manager/models/member_model.dart';
import 'package:work_flow_manager/models/task_model.dart';
import 'package:work_flow_manager/repository/tasks/tasks_repository.dart';
import 'package:work_flow_manager/repository/tasks/tasks_state.dart';
import 'package:work_flow_manager/view/widgets/widgets.dart';

class CreateTaskView extends StatefulWidget {
  final String? projectId;
  const CreateTaskView({super.key, this.projectId});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  MemberModel? selectedMember;

  void _resetForm() {
    nameController.clear();
    nameController.text = '';
    descriptionController.clear();
    descriptionController.text = '';
    startDateController.clear();
    startDateController.text = '';
    endDateController.clear();
    endDateController.text = '';
    setState(() {
      selectedMember = null;
    });
  }

  void _createTask(BuildContext context) {
    if (_formKey.currentState!.validate() && selectedMember != null) {
      final now = DateTime.now();
      final startDateParsed = DateTime.parse(startDateController.text);
      final endDateParsed = DateTime.parse(endDateController.text);

      TaskModel task = TaskModel(
        name: nameController.text,
        description: descriptionController.text,
        startDate: DateTime(
          startDateParsed.year,
          startDateParsed.month,
          startDateParsed.day,
          0,
        ),
        endDate: DateTime(
          endDateParsed.year,
          endDateParsed.month,
          endDateParsed.day,
          23,
        ),
        createdAt: DateTime.now(),
        assignedMember: selectedMember!.id!,
        projectId: widget.projectId!,
        id: getIt<FirebaseFirestore>().collection("tasks").doc().id,
        workedHours: 0,
        assignedMemberName: selectedMember!.name,
      );
      context.read<TasksRepository>().addTask(task, widget.projectId!);
    }
  }

  void pickDate(TextEditingController field) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDateController.text.isNotEmpty
          ? DateTime.parse(startDateController.text)
          : DateTime.now(),
      firstDate: startDateController.text.isNotEmpty
          ? DateTime.parse(startDateController.text)
          : DateTime(1950),
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

  Widget _form(TasksLoadedState state, BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          CustomTextField(
            labelText: 'Nombre de la tarea',
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
            items: state.members.map((member) => member.name).toList(),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                labelText: "Selecciona un miembro",
                labelStyle: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.bodyMedium!.fontFamily,
                    fontSize: 15),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                selectedMember = state.members.firstWhere(
                  (element) => element.name == newValue,
                );
              });
            },
          ),
          const SizedBox(height: 80),
          CustomButton(
            child: const Text(
              'Crear',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onPressed: () => _createTask(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TasksRepository>()..getMembers(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.appColor,
          title: const Text(
            'Crear tarea',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: BlocConsumer<TasksRepository, TasksState>(
          listener: (context, state) => {
            if (state is TasksLoadedState && state.wasTaskCreated)
              {
                _resetForm(),
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tarea creada exitosamente'),
                  ),
                ),
                Navigator.pop(context),
              }
          },
          builder: (BuildContext context, TasksState state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Builder(
                  builder: (BuildContext context) {
                    if (state is TasksLoadedState) {
                      return _form(state, context);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
