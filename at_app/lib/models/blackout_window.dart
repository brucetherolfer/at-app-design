import 'package:isar/isar.dart';

part 'blackout_window.g.dart';

@collection
class BlackoutWindow {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  late String label;

  late List<int> daysOfWeek; // 1=Mon...7=Sun

  late String startTime; // "HH:mm"

  late String endTime; // "HH:mm"

  bool isEnabled = true;
}
