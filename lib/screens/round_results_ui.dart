import 'package:flutter/material.dart';
import 'package:alias/models/team.dart';
import 'package:alias/models/game_word.dart';
import 'package:alias/resources_app/colors.dart';
import 'package:alias/resources_app/widgets_btn.dart';

class RoundResultsUi extends StatefulWidget {
  final Team team;
  final List<GameWord> playedWords;

  const RoundResultsUi({
    super.key,
    required this.team,
    required this.playedWords,
  });

  @override
  State<RoundResultsUi> createState() => _RoundResultsUiState();
}

class _RoundResultsUiState extends State<RoundResultsUi> {
  late int _currentScore;

  @override
  void initState() {
    super.initState();
    _calculateScore();
  }

  void _calculateScore() {
    _currentScore = widget.playedWords.where((gw) => gw.isGuessed).length;
  }

  void _toggleWordStatus(int index) {
    setState(() {
      widget.playedWords[index].isGuessed =
          !widget.playedWords[index].isGuessed;
      _calculateScore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: const BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),
              ),
              child: Column(
                children: [
                  _myText(widget.team.name, 20, false),
                  const SizedBox(height: 5),
                  _myText("$_currentScore", 40, true),
                  const SizedBox(height: 5),
                  _myText("ВГАДАНО", 20, true),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              "Результати раунду",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Word List
            Expanded(
              child: widget.playedWords.isEmpty
                  ? const Center(child: Text("Немає зіграних слів"))
                  : ListView.builder(
                      itemCount: widget.playedWords.length,
                      itemBuilder: (context, index) {
                        final gameWord = widget.playedWords[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            title: Text(
                              gameWord.text, // <-- зміни тут
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                gameWord.isGuessed
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: gameWord.isGuessed
                                    ? AppColors.green
                                    : Colors.red,
                                size: 30,
                              ),
                              onPressed: () => _toggleWordStatus(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Finish Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CommonButtons(
                text: "Завершити раунд",
                onPressed: () {
                  Navigator.pop(context, _currentScore);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myText(String title, double size, bool fontWeightBold) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.white,
        fontSize: size,
        fontWeight: fontWeightBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
