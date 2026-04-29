import 'package:flutter/material.dart';
import 'package:alias/resources_app/colors.dart';
// import 'package:alias/screens/words_management/words_management_ui.dart';
// import 'package:alias/screens/words_management/groups_management_ui.dart';

class SettingsAppUi extends StatefulWidget {
  const SettingsAppUi({super.key});

  @override
  State<SettingsAppUi> createState() => _SettingsAppUiState();
}

class _SettingsAppUiState extends State<SettingsAppUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Налаштуваня програми",
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.green,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Налаштування слів'),
            subtitle: const Text('Перегляд та редагування списку слів'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const WordsManagementScreen(),
              //   ),
              // );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Налаштування груп слів'),
            subtitle: const Text('Створення та керування темами'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const GroupsManagementScreen(),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}
