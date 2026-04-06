import 'package:isar/isar.dart';

part 'sequence.g.dart';

@collection
class Sequence {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  late String name;

  late List<String> promptUids; // ordered

  late int gapSeconds; // default 2

  late bool isBuiltIn;

  late DateTime createdAt;
}
