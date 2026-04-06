import 'package:isar/isar.dart';
import '../models/blackout_window.dart';
import 'isar_service.dart';

class BlackoutRepository {
  Isar get _db => IsarService.instance;

  Future<List<BlackoutWindow>> getAll() async {
    return _db.blackoutWindows.where().findAll();
  }

  Stream<List<BlackoutWindow>> watchAll() {
    return _db.blackoutWindows.where().watch(fireImmediately: true);
  }

  Future<void> save(BlackoutWindow window) async {
    await _db.writeTxn(() async {
      await _db.blackoutWindows.put(window);
    });
  }

  Future<void> delete(String uid) async {
    await _db.writeTxn(() async {
      final w = await _db.blackoutWindows.filter().uidEqualTo(uid).findFirst();
      if (w != null) await _db.blackoutWindows.delete(w.id);
    });
  }
}
