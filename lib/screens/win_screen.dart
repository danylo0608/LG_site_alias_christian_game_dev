import 'package:flutter/material.dart';
import 'package:alias/models/team.dart';
import 'package:alias/resources_app/colors.dart';
import 'package:alias/resources_app/widgets_btn.dart';
class WinScreen extends StatelessWidget {
  final Team winner;
  final List<Team> teams;

  const WinScreen({super.key, required this.winner, required this.teams});

  @override
  Widget build(BuildContext context) {
    // Sort teams by score descending
    final sortedTeams = List<Team>.from(teams)
      ..sort((a, b) => b.score.compareTo(a.score));

    return Scaffold(
      backgroundColor: AppColors.green,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "ПЕРЕМОЖЕЦЬ",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
                  Text(
                    winner.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    "${winner.score}",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Результати",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: sortedTeams.length,
                        itemBuilder: (context, index) {
                          final team = sortedTeams[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.green,
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(color: AppColors.white),
                              ),
                            ),
                            title: Text(
                              team.name,
                              style: const TextStyle(fontSize: 20),
                            ),
                            trailing: Text(
                              "${team.score}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CommonButtons(
                        text: "На головну",
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
