import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alias/models/team.dart';
import 'package:alias/models/group.dart';
import 'package:alias/screens/team_rating_ui.dart';
import 'package:alias/resources_app/colors.dart';
import 'package:alias/resources_app/widgets_btn.dart';

class ThemeSelectionUi extends StatefulWidget {
  final List<Team> teams;
  final int roundTime;
  final int winningScore; // додано
  final bool penaltyForSkip;
  final List<String> selectedGroupIds;
  final String gamePath;

  const ThemeSelectionUi({
    super.key,
    required this.teams,
    required this.roundTime,
    required this.winningScore, // додано
    required this.penaltyForSkip,
    this.selectedGroupIds = const [],
    required this.gamePath,
  });

  @override
  State<ThemeSelectionUi> createState() => _ThemeSelectionUiState();
}

class _ThemeSelectionUiState extends State<ThemeSelectionUi> {
  List<WordGroup> _groups = [];
  final Set<String> _selectedGroupIds = {};

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/${widget.gamePath}/groups.json',
      );
      final data = json.decode(jsonString);
      final groups = (data['groups'] as List)
          .map((g) => WordGroup(id: g['id'], name: g['name'], file: g['file']))
          .toList();

      for (var group in groups) {
        if (group.file != null) {
          try {
            final groupJsonString = await rootBundle.loadString(
              'assets/data/${widget.gamePath}/${group.file}',
            );
            final groupData = json.decode(groupJsonString);
            final wordsList = groupData['words'] as List?;
            if (wordsList != null) {
              group.wordCount = wordsList.length;
            }
          } catch (e) {
            debugPrint("Error loading words for ${group.id}: $e");
          }
        }
      }

      setState(() {
        _groups = groups;
      });
    } catch (e) {
      debugPrint("Error loading groups: $e");
    }
  }

  void _startGame() {
    if (_selectedGroupIds.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamRatingUi(
          teams: widget.teams,
          roundTime: widget.roundTime,
          winningScore: widget.winningScore,
          penaltyForSkip: widget.penaltyForSkip,
          selectedGroupKeys: _selectedGroupIds.toList(),
          gamePath: widget.gamePath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вибір теми', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.green,
      ),
      body: _groups.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _groups.length,
                    itemBuilder: (context, index) {
                      final group = _groups[index];
                      final checked = _selectedGroupIds.contains(group.id);
                      return ListTile(
                        leading: const Icon(Icons.category),
                        title: Text(group.name),
                        subtitle: group.wordCount != null
                            ? Text("Слів: ${group.wordCount}")
                            : null,
                        trailing: Checkbox(
                          value: checked,
                          onChanged: (v) {
                            setState(() {
                              if (v == true) {
                                _selectedGroupIds.add(group.id);
                              } else {
                                _selectedGroupIds.remove(group.id);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CommonButtons(
                  text: "Почати гру",
                  onPressed: _selectedGroupIds.isEmpty ? null : _startGame,
                ),
                const SizedBox(height: 70),
              ],
            ),
    );
  }
}
