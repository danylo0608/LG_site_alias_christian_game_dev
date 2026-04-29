import 'package:flutter/material.dart';
import 'package:alias/models/team.dart';
import 'package:alias/resources_app/colors.dart';
import 'package:alias/resources_app/widgets_btn.dart';
import 'package:alias/screens/settings_game_ui.dart';

class CommandNameUi extends StatefulWidget {
  const CommandNameUi({super.key});

  @override
  State<CommandNameUi> createState() => _CommandNameUiState();
}

class _CommandNameUiState extends State<CommandNameUi> {
  final TextEditingController controller = TextEditingController();
  final List<Team> teams = [];

  void addTeam(String name) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return;

    // Перевіряємо, чи вже є команда з такою назвою (регістр неважливий: "Кіт" == "кіт")
    bool alreadyExists = teams.any(
      (team) => team.name.toLowerCase() == trimmedName.toLowerCase(),
    );

    if (alreadyExists) {
      // Можна вивести повідомлення користувачу
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Команда з такою назвою вже існує!')),
      );
      return;
    }

    setState(() {
      teams.add(Team(name: name));
    });
  }

  // Метод для видалення
  void deleteTeam(int index) {
    setState(() {
      teams.removeAt(index);
    });
  }

  // Метод для редагування через діалогове вікно
  void editTeam(int index) {
    final TextEditingController editController = TextEditingController(
      text: teams[index].name,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Редагувати назву"),
          content: TextField(controller: editController),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Скасувати"),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.trim().isNotEmpty) {
                  setState(() {
                    teams[index].name = editController.text;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Зберегти"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Назви команд", style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Назва нової команди',
              ),
            ),
            const SizedBox(height: 12),
            CommonButtons(
              text: "Додати команду",
              onPressed: () {
                addTeam(controller.text);
                controller.clear();
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  return Card(
                    // Додаємо Card для гарнішого вигляду
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(teams[index].name),
                      trailing: Row(
                        // Додаємо іконки в кінець рядка
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => editTeam(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteTeam(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            CommonButtons(
              text: "Далі",
              onPressed: () {
                if (teams.length < 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Додайте хоча б 2 команди")),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsGameUi(
                      teams: teams,
                      gamePath:
                          'alias_christian_game', // <--- тут вкажи потрібний шлях до гри
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
