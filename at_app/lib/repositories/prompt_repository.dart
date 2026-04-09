import 'package:isar/isar.dart';
import '../models/prompt.dart';
import 'isar_service.dart';

class PromptRepository {
  Isar get _db => IsarService.instance;

  Future<List<Prompt>> getByLibrary(String libraryUid) async {
    return _db.prompts
        .filter()
        .libraryUidEqualTo(libraryUid)
        .sortBySortOrder()
        .findAll();
  }

  Stream<List<Prompt>> watchByLibrary(String libraryUid) {
    return _db.prompts
        .filter()
        .libraryUidEqualTo(libraryUid)
        .sortBySortOrder()
        .watch(fireImmediately: true);
  }

  Future<Prompt?> getByUid(String uid) async {
    return _db.prompts.filter().uidEqualTo(uid).findFirst();
  }

  Future<void> save(Prompt prompt) async {
    await _db.writeTxn(() async {
      await _db.prompts.put(prompt);
    });
  }

  Future<void> saveAll(List<Prompt> prompts) async {
    await _db.writeTxn(() async {
      await _db.prompts.putAll(prompts);
    });
  }

  Future<void> delete(String uid) async {
    await _db.writeTxn(() async {
      final p = await _db.prompts.filter().uidEqualTo(uid).findFirst();
      if (p != null) await _db.prompts.delete(p.id);
    });
  }

  Future<int> countByLibrary(String libraryUid) async {
    return _db.prompts.filter().libraryUidEqualTo(libraryUid).count();
  }
}
