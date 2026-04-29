import 'package:flutter/material.dart';
import 'package:alias/resources_app/colors.dart';
import 'package:alias/resources_app/widgets_btn.dart';
import 'package:alias/screens/theme_selection_ui.dart';
import 'package:alias/models/team.dart';

class SettingsGameUi extends StatefulWidget {
  final List<Team> teams;
  final String gamePath;

  const SettingsGameUi({
    super.key,
    required this.teams,
    required this.gamePath,
  });

  @override
  State<SettingsGameUi> createState() => _SettingsGameUiState();
}

class _SettingsGameUiState extends State<SettingsGameUi> {
  int roundTime = 60;
  int winningWords = 60;
  bool penaltyForSkip = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Налаштування гри",
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              _buildSettingRow(
                title: 'Час раунду',
                subtitle: 'тривалість у секундах',
                value: roundTime,
                onMinus: () {
                  if (roundTime > 5) setState(() => roundTime -= 5);
                },
                onPlus: () => setState(() => roundTime += 5),
              ),
              const SizedBox(height: 40),
              _buildSettingRow(
                title: 'Кількість слів',
                subtitle: 'для перемоги',
                value: winningWords,
                onMinus: () {
                  if (winningWords > 5) setState(() => winningWords -= 5);
                },
                onPlus: () => setState(() => winningWords += 5),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Штраф за пропуск',
                        style: TextStyle(
                          fontSize: 26,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'віднімати 1 бал',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.black54,
                        ),
                      ),
                    ],
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      value: penaltyForSkip,
                      onChanged: (value) {
                        setState(() {
                          penaltyForSkip = value ?? false;
                        });
                      },
                      activeColor: AppColors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              CommonButtons(
                text: "Далі",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThemeSelectionUi(
                        teams: widget.teams,
                        roundTime: roundTime,
                        winningScore: winningWords,
                        penaltyForSkip: penaltyForSkip,
                        gamePath: widget.gamePath,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingRow({
    required String title,
    required String subtitle,
    required int value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.black54,
                  ),
                ),
              ],
            ),
            Text(
              '$value',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _actionButton(Icons.remove, onMinus),
            _actionButton(Icons.add, onPlus),
          ],
        ),
      ],
    );
  }

  Widget _actionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        height: 55,
        decoration: const BoxDecoration(
          color: AppColors.green,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 40),
      ),
    );
  }
}
