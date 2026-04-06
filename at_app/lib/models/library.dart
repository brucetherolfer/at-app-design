import 'package:isar/isar.dart';

part 'library.g.dart';

@collection
class Library {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid; // UUID string

  late String name;

  late bool isBuiltIn;

  late int sortOrder;

  late DateTime createdAt;
}
