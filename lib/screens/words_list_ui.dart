import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alias/resources_app/colors.dart';

class WordsListUi extends StatefulWidget {
  final String groupName;
  final String fileName;
  final String gamePath;

  const WordsListUi({
    super.key,
    required this.groupName,
    required this.fileName,
    required this.gamePath,
  });

  @override
  State<WordsListUi> createState() => _WordsListUiState();
}

class _WordsListUiState extends State<WordsListUi> {
  List<String> _words = [];

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/${widget.gamePath}/${widget.fileName}',
      );
      final data = json.decode(jsonString);
      final wordsList = (data['words'] as List).map((w) => w.toString()).toList();

      setState(() {
        _words = wordsList;
      });
    } catch (e) {
      debugPrint("Error loading words from ${widget.fileName}: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName, style: const TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.green,
      ),
      body: _words.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _words.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text('${index + 1}.', style: const TextStyle(color: AppColors.black54)),
                  title: Text(_words[index], style: const TextStyle(fontSize: 18)),
                );
              },
            ),
    );
  }
}
