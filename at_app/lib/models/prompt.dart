import 'package:isar/isar.dart';

part 'prompt.g.dart';

@collection
class Prompt {
  Id id = Isar.autoIncrement;

  @Index()
  late String uid; // UUID string

  late String text;

  @Index()
  late String libraryUid;

  late int sortOrder;

  late bool isBuiltIn;

  late DateTime createdAt;
}
