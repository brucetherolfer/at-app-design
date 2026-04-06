import 'package:isar/isar.dart';
import '../models/sequence.dart';
import 'isar_service.dart';

class SequenceRepository {
  Isar get _db => IsarService.instance;

  Future<List<Sequence>> getAll() async {
    return _db.sequences.where().findAll();
  }

  Stream<List<Sequence>> watchAll() {
    return _db.sequences.where().watch(fireImmediately: true);
  }

  Future<Sequence?> getByUid(String uid) async {
    return _db.sequences.filter().uidEqualTo(uid).findFirst();
  }

  Future<void> save(Sequence sequence) async {
    await _db.writeTxn(() async {
      await _db.sequences.put(sequence);
    });
  }

  Future<void> delete(String uid) async {
    await _db.writeTxn(() async {
      final s = await _db.sequences.filter().uidEqualTo(uid).findFirst();
      if (s != null) await _db.sequences.delete(s.id);
    });
  }
}
