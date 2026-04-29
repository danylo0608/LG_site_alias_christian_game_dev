import 'package:hive/hive.dart';

part 'word.g.dart';

@HiveType(typeId: 0)
class Word extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  bool isEnabled;

  @HiveField(2)
  int? id;

  @HiveField(3)
  List<int> groupIds;

  Word({
    required this.text,
    this.isEnabled = true,
    this.id,
    List<int>? groupIds,
  }) : groupIds = groupIds ?? [];
}
