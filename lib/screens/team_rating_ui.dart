import 'package:flutter/material.dart';
import 'package:alias/resources_app/colors.dart';
import 'package:alias/resources_app/widgets_btn.dart';
import 'package:alias/screens/game_ui.dart';
import 'package:alias/screens/win_screen.dart';
import 'package:alias/models/team.dart';

class TeamRatingUi extends StatefulWidget {
  final List<Team> teams;
  final int roundTime;
  final int winningScore;
  final bool penaltyForSkip;
  final List<String> selectedGroupKeys;
  final String gamePath;

  const TeamRatingUi({
    super.key,
    required this.teams,
    required this.roundTime,
    required this.winningScore,
    required this.penaltyForSkip,
    this.selectedGroupKeys = const [],
    required this.gamePath,
  });

  @override
  State<TeamRatingUi> createState() => _TeamRatingUiState();
}

class _TeamRatingUiState extends State<TeamRatingUi> {
  int currentTeamIndex = 0;

  void _startRound() async {
    final currentTeam = widget.teams[currentTeamIndex % widget.teams.length];

    // Navigate to GameUi and wait for result (score added in this round)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameUi(
          teams: [
            currentTeam,
          ], // передаємо команду як список, щоб JSON версія працювала
          roundTime: widget.roundTime,
          penaltyForSkip: widget.penaltyForSkip,
          selectedGroupIds: widget.selectedGroupKeys,
          gamePath: widget.gamePath,
        ),
      ),
    );

    if (result != null && result is int) {
      setState(() {
        currentTeam.score += result;
        currentTeamIndex++;
      });
      _checkWinner();
    }
  }

  void _checkWinner() {
    // Only check for winner if all teams have played the same number of rounds
    if (currentTeamIndex % widget.teams.length == 0) {
      // Find team with highest score
      Team? winner;
      int maxScore = -1;

      for (var team in widget.teams) {
        if (team.score >= widget.winningScore && team.score > maxScore) {
          maxScore = team.score;
          winner = team;
        }
      }

      if (winner != null) {
        // We have a winner!
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WinScreen(winner: winner!, teams: widget.teams),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTeam = widget.teams[currentTeamIndex % widget.teams.length];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Верхня зелена плашка з рейтингом
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              decoration: const BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),
              ),
              child: Column(
                children: [
                  _buildRatingRow(
                    'Рейтинг\nкоманд',
                    '${widget.winningScore}',
                    isHeader: true,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.teams.length,
                      itemBuilder: (context, index) {
                        final team = widget.teams[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: _buildRatingRow(team.name, '${team.score}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Центральний блок "підготовки"
            Column(
              children: [
                const Text(
                  "До раунду готується:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 10),
                Text(
                  currentTeam.name,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Кнопка "Поїхали"
            CommonButtons(text: "Поїхали!", onPressed: _startRound),

            const SizedBox(height: 16),

            // Кнопка "Закінчити гру"
            CommonButtons(text: "Закінчити гру", onPressed: _confirmFinishGame),

            const Spacer(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Віджет для рядка рейтингу
  Widget _buildRatingRow(String title, String score, {bool isHeader = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.white,
            fontSize: isHeader ? 32 : 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          score,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _confirmFinishGame() async {
    final shouldFinish = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Закінчити гру?"),
          content: const Text("Ви впевнені, що хочете завершити гру зараз?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Скасувати"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Так"),
            ),
          ],
        );
      },
    );

    if (shouldFinish == true) {
      _finishGameNow();
    }
  }

  void _finishGameNow() {
    Team? winner;
    int maxScore = -1;
    for (var team in widget.teams) {
      if (team.score > maxScore) {
        maxScore = team.score;
        winner = team;
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WinScreen(
          winner: winner ?? widget.teams.first,
          teams: widget.teams,
        ),
      ),
    );
  }
}
