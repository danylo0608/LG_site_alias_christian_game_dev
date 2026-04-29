import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alias/models/team.dart';
import 'package:alias/resources_app/colors.dart';
import 'package:alias/resources_app/widgets_btn.dart';
import 'package:alias/screens/round_results_ui.dart';
import 'package:alias/models/game_word.dart';


class GameUi extends StatefulWidget {
  final List<Team> teams;
  final int roundTime;
  final bool penaltyForSkip;
  final List<String> selectedGroupIds;
  final String gamePath;

  const GameUi({
    super.key,
    required this.teams,
    required this.roundTime,
    required this.penaltyForSkip,
    required this.selectedGroupIds,
    required this.gamePath,
  });

  @override
  State<GameUi> createState() => _GameUiState();
}

class _GameUiState extends State<GameUi> {
  List<GameWord> _availableWords = [];
  final List<GameWord> _playedWords = [];
  Timer? _timer;
  late int _timeLeft;
  bool _isPaused = true;
  bool _isLastWord = false;
  int _currentWordIndex = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.roundTime;
    _loadWords();
  }

  Future<void> _loadWords() async {
    List<GameWord> words = [];

    for (final groupId in widget.selectedGroupIds) {
      try {
        final groupsJson = await rootBundle.loadString(
          'assets/data/${widget.gamePath}/groups.json',
        );
        final groupsData = json.decode(groupsJson)['groups'] as List;
        final group = groupsData.firstWhere((g) => g['id'] == groupId);
        final file = group['file'];

        final groupWordsJson = await rootBundle.loadString(
          'assets/data/${widget.gamePath}/$file',
        );
        final groupWordsData = json.decode(groupWordsJson)['words'] as List;
        words.addAll(groupWordsData.map((w) => GameWord(w.toString())));
      } catch (e) {
        debugPrint("Error loading words for group $groupId: $e");
      }
    }

    if (words.isEmpty) {
      words.add(GameWord("Немає слів!"));
    }

    words.shuffle(Random());

    setState(() {
      _availableWords = words;
    });
  }

  void _startTimer() {
    setState(() => _isPaused = false);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer?.cancel();
        setState(() => _isLastWord = true);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isPaused = true);
  }

  void _handleSpacebar(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      if (!_isPaused && _availableWords.isNotEmpty) {
        // Spacebar is treated as "guessed" (swipe up)
        _handleSwipe(true);
      }
    }
  }

  void _handleSwipe(bool isGuessed) {
    if (_availableWords.isEmpty) return;

    final currentWord = _availableWords[_currentWordIndex];
    currentWord.isGuessed = isGuessed;
    _playedWords.add(currentWord);

    if (isGuessed) {
      _score++;
    } else {
      if (widget.penaltyForSkip) {
        _score--;
      }
    }

    if (_isLastWord) {
      _finishRound();
    } else {
      setState(() {
        _currentWordIndex = (_currentWordIndex + 1) % _availableWords.length;
      });
    }
  }

  void _finishRound() async {
    _timer?.cancel();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RoundResultsUi(team: widget.teams[0], playedWords: _playedWords),
      ),
    );

    if (!mounted) return;

    if (result != null && result is int) {
      Navigator.pop(context, result);
    } else {
      Navigator.pop(context, _score);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_availableWords.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentWord = _availableWords[_currentWordIndex];

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
                  Text(
                    widget.teams[0].name,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "$_score",
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "ВГАДАНО",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Game area
            _isPaused
                ? GestureDetector(
                    onTap: _startTimer,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: const BoxDecoration(
                        color: AppColors.grey,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _timeLeft == widget.roundTime ? 'ПОЧАТИ' : 'ПРОДОВЖИТИ',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : KeyboardListener(
                    focusNode: FocusNode()..requestFocus(),
                    onKeyEvent: _handleSpacebar,
                    child: Dismissible(
                      key: ValueKey(
                        currentWord.text + _currentWordIndex.toString(),
                      ),
                      direction: DismissDirection.vertical,
                      onDismissed: (direction) {
                        _handleSwipe(direction == DismissDirection.up);
                      },
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                currentWord.text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            const Spacer(),
            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: _isLastWord ? Colors.red : AppColors.green,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(80),
                  topRight: Radius.circular(80),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _isLastWord ? "ЧАС ВИЙШОВ!" : "$_timeLeft с",
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (!_isLastWord)
                    CommonButtons(
                      text: _isPaused ? "Продовжити" : "Стоп",
                      onPressed: _isPaused ? _startTimer : _pauseTimer,
                      outlined: true,
                    ),
                  if (_isLastWord)
                    const Text(
                      "Завершіть дію (свайп)",
                      style: TextStyle(color: Colors.white),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
