import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/injections.dart';
import 'package:work_flow_manager/repository/record/record_repository.dart';
import 'package:work_flow_manager/repository/record/record_state.dart';
import 'package:work_flow_manager/view/record/create_record_view.dart';
import 'package:work_flow_manager/view/widgets/custom_text_field.dart';

class RecordsView extends StatelessWidget {
  RecordsView({super.key, required this.taskId});

  final String taskId;

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RecordRepository>()..getRecordsByTasks(taskId),
      child: BlocBuilder<RecordRepository, RecordState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppTheme.appColor,
              title: const Text("Mis Registros"),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppTheme.appColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CreateRecordView(taskId: taskId);
                    },
                  ),
                ).then((_) =>
                    context.read<RecordRepository>().getRecordsByTasks(taskId));
              },
              child: const Icon(Icons.add),
            ),
            body: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: CustomTextField(
                    labelText: "Buscar registro",
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                Builder(
                  builder: (context) {
                    if (state is RecordLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is RecordLoadedState) {
                      return state.records.isNotEmpty
                          ? Expanded(
                              child: ListView.separated(
                                itemCount: state.records.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: const Icon(Icons.add_task),
                                    title: Text(state.records[index].name),
                                    trailing: FittedBox(
                                      child: Row(
                                        children: [
                                          Text(
                                              "${state.records[index].workedHours}hrs"),
                                          const SizedBox(width: 20),
                                          const Icon(Icons.arrow_forward_ios),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return CreateRecordView(
                                              taskId: taskId,
                                              recordToUpdate:
                                                  state.records[index],
                                            );
                                          },
                                        ),
                                      ).then((_) => context
                                          .read<RecordRepository>()
                                          .getRecordsByTasks(taskId));
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  height: 2,
                                ),
                              ),
                            )
                          : const Center(
                              child: Text("No hay registros"),
                            );
                    } else {
                      return const Center(
                        child: Text("No hay registros"),
                      );
                    }
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
