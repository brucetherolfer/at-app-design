import 'package:isar/isar.dart';
import '../models/library.dart';
import '../models/prompt.dart';
import 'isar_service.dart';

class LibraryRepository {
  Isar get _db => IsarService.instance;

  Future<List<Library>> getAll() async {
    return _db.librarys.where().sortBySortOrder().findAll();
  }

  Stream<List<Library>> watchAll() {
    return _db.librarys.where().sortBySortOrder().watch(fireImmediately: true);
  }

  Future<Library?> getByUid(String uid) async {
    return _db.librarys.filter().uidEqualTo(uid).findFirst();
  }

  Future<void> save(Library library) async {
    await _db.writeTxn(() async {
      await _db.librarys.put(library);
    });
  }

  Future<void> delete(String uid) async {
    await _db.writeTxn(() async {
      final lib = await _db.librarys.filter().uidEqualTo(uid).findFirst();
      if (lib != null) await _db.librarys.delete(lib.id);
      // Also delete all prompts in this library
      final prompts = await _db.prompts.filter().libraryUidEqualTo(uid).findAll();
      await _db.prompts.deleteAll(prompts.map((p) => p.id).toList());
    });
  }
}
