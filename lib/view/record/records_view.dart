import 'package:flutter/material.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/view/widgets/custom_text_field.dart';

class RecordItem {
  const RecordItem({
    required this.name,
    required this.workedHours,
  });

  final String name;
  final String workedHours;
}

List<RecordItem> records = const [
  RecordItem(
    name: 'Registro 1',
    workedHours: '8hrs',
  ),
  RecordItem(
    name: 'Registro 2',
    workedHours: '8hrs',
  ),
  RecordItem(
    name: 'Registro 3',
    workedHours: '8hrs',
  ),
  RecordItem(
    name: 'Registro 4',
    workedHours: '8hrs',
  ),
];

class RecordsView extends StatelessWidget {
  RecordsView({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.nearlyDarkBlue,
        title: const Text(
          'Registros',
          style: TextStyle(fontSize: 18),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.nearlyDarkBlue,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: CustomTextField(
              labelText: "Buscar registro",
              controller: searchController,
              keyboardType: TextInputType.text,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: records.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.add_task),
                  title: Text(records[index].name),
                  trailing: FittedBox(
                    child: Row(
                      children: [
                        Text(records[index].workedHours),
                        const SizedBox(width: 20),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                  onTap: () {},
                );
              },
              separatorBuilder: (context, index) => const Divider(
                height: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
