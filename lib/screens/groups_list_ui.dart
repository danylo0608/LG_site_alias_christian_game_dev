import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alias/models/group.dart';
import 'package:alias/resources_app/colors.dart';
import 'package:alias/screens/words_list_ui.dart';

class GroupsListUi extends StatefulWidget {
  final String gamePath;

  const GroupsListUi({super.key, this.gamePath = 'alias_christian_game'});

  @override
  State<GroupsListUi> createState() => _GroupsListUiState();
}

class _GroupsListUiState extends State<GroupsListUi> {
  List<WordGroup> _groups = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Групи слів', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.green,
      ),
      body: _groups.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _groups.length,
              itemBuilder: (context, index) {
                final group = _groups[index];
                return ListTile(
                  leading: const Icon(Icons.folder, color: AppColors.green),
                  title: Text(group.name),
                  subtitle: group.wordCount != null
                      ? Text("Слів: ${group.wordCount}")
                      : null,
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    if (group.file != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WordsListUi(
                            groupName: group.name,
                            fileName: group.file!,
                            gamePath: widget.gamePath,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
