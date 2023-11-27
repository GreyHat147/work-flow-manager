import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/injections.dart';
import 'package:work_flow_manager/models/record_model.dart';
import 'package:work_flow_manager/repository/record/record_repository.dart';
import 'package:work_flow_manager/repository/record/record_state.dart';
import 'package:work_flow_manager/view/widgets/widgets.dart';

class CreateRecordView extends StatefulWidget {
  const CreateRecordView({
    super.key,
    required this.taskId,
    this.recordToUpdate,
  });

  final RecordModel? recordToUpdate;

  final String taskId;

  @override
  State<CreateRecordView> createState() => _CreateRecordViewState();
}

class _CreateRecordViewState extends State<CreateRecordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  TimeOfDay _startTimeSelected = TimeOfDay.now();
  TimeOfDay _endTimeSelected = TimeOfDay.now();

  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    if (widget.recordToUpdate != null) {
      _isUpdating = true;
      nameController.text = widget.recordToUpdate!.name;
      descriptionController.text = widget.recordToUpdate!.description;
      startDateController.text =
          '${widget.recordToUpdate!.startDate.hour}:${widget.recordToUpdate!.startDate.minute}';
      endDateController.text =
          '${widget.recordToUpdate!.endDate.hour}:${widget.recordToUpdate!.endDate.minute}';
      _startTimeSelected = TimeOfDay(
        hour: widget.recordToUpdate!.startDate.hour,
        minute: widget.recordToUpdate!.startDate.minute,
      );
      _endTimeSelected = TimeOfDay(
        hour: widget.recordToUpdate!.endDate.hour,
        minute: widget.recordToUpdate!.endDate.minute,
      );
    }
  }

  Future<TimeOfDay?> getTime(BuildContext context,
      [TimeOfDay? pickedTime]) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: pickedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: false,
              ),
              child: child!,
            ),
          ),
        );
      },
    );
    return time;
  }

  void _handle(BuildContext context) {
    if (_isUpdating) {
      _update(context);
    } else {
      _create(context);
    }
  }

  void _update(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final DateTime now = DateTime.now();
      final DateTime startTime = DateTime(
        now.year,
        now.month,
        now.day,
        _startTimeSelected.hour,
        _startTimeSelected.minute,
      );

      final DateTime endTime = DateTime(
        now.year,
        now.month,
        now.day,
        _endTimeSelected.hour,
        _endTimeSelected.minute,
      );

      final RecordModel recordModel = RecordModel(
        id: widget.recordToUpdate!.id,
        name: nameController.text,
        description: descriptionController.text,
        startDate: startTime,
        endDate: endTime,
        createdAt: now,
        taskId: widget.taskId,
        workedHours: endTime.difference(startTime).inHours,
      );

      await context.read<RecordRepository>().updateRecord(recordModel);
    }
  }

  void _create(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String recordId =
          getIt<FirebaseFirestore>().collection("records").doc().id;

      final DateTime now = DateTime.now();
      final DateTime startTime = DateTime(
        now.year,
        now.month,
        now.day,
        _startTimeSelected.hour,
        _startTimeSelected.minute,
      );

      final DateTime endTime = DateTime(
        now.year,
        now.month,
        now.day,
        _endTimeSelected.hour,
        _endTimeSelected.minute,
      );

      final RecordModel recordModel = RecordModel(
        id: recordId,
        name: nameController.text,
        description: descriptionController.text,
        startDate: startTime,
        endDate: endTime,
        createdAt: now,
        taskId: widget.taskId,
        workedHours: endTime.difference(startTime).inHours,
      );

      await context.read<RecordRepository>().addRecord(recordModel);
    }
  }

  void _delete(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar Registro"),
        content: const Text("¿Está seguro que desea eliminar el registro?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              await context
                  .read<RecordRepository>()
                  .deleteRecord(widget.recordToUpdate!.id!);
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RecordRepository>(),
      child: BlocConsumer<RecordRepository, RecordState>(
        listener: (BuildContext context, RecordState state) {
          if (state is RecordLoadedState && state.recordCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registro creado exitosamente'),
              ),
            );
            Navigator.pop(context);
          }

          if (state is RecordLoadedState && state.recordUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registro actualizado exitosamente'),
              ),
            );
            Navigator.pop(context);
          }

          if (state is RecordLoadedState && state.recordDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registro eliminado exitosamente'),
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppTheme.appColor,
              title: Text(
                _isUpdating ? 'Actualizar registro' : 'Crear registro',
                style: const TextStyle(fontSize: 18),
              ),
              actions: [
                if (_isUpdating)
                  IconButton(
                    onPressed: () => _delete(context),
                    icon: const Icon(Icons.delete),
                  )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Form(
                  key: _formKey,
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
                        labelText: 'Hora de inicio',
                        controller: startDateController,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.calendar_month),
                        readOnly: true,
                        onTap: () async {
                          final pickedTime =
                              await getTime(context, _startTimeSelected);

                          if (pickedTime != null) {
                            startDateController.text =
                                '${pickedTime.hour}:${pickedTime.minute}';
                            _startTimeSelected = pickedTime;
                          }
                        },
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        labelText: 'Hora de fin',
                        controller: endDateController,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.calendar_month),
                        readOnly: true,
                        onTap: () async {
                          final pickedTime =
                              await getTime(context, _endTimeSelected);

                          if (pickedTime != null) {
                            endDateController.text =
                                '${pickedTime.hour}:${pickedTime.minute}';
                            _endTimeSelected = pickedTime;
                          }
                        },
                      ),
                      const SizedBox(height: 80),
                      CustomButton(
                        onPressed: () => _handle(context),
                        child: Text(
                          _isUpdating ? 'Actualizar' : 'Crear',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
