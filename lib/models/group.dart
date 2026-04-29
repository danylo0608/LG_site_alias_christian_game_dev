import 'package:hive/hive.dart';

part 'group.g.dart';

@HiveType(typeId: 1)
class WordGroup {
  @HiveField(0)
  final String id; // нове поле

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? file; // optional, якщо з JSON треба файл групи

  @HiveField(4)
  int? wordCount; // нове поле для кількості слів

  WordGroup({
    required this.id,
    required this.name,
    this.description,
    this.file,
    this.wordCount,
  });
}
