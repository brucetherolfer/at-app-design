import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/library.dart';
import '../models/prompt.dart';
import 'repository_providers.dart';

const _uuid = Uuid();

final librariesProvider = StreamProvider<List<Library>>((ref) {
  return ref.watch(libraryRepositoryProvider).watchAll();
});

final libraryByUidProvider = Provider.family<Library?, String>((ref, uid) {
  final libs = ref.watch(librariesProvider).valueOrNull ?? [];
  try {
    return libs.firstWhere((l) => l.uid == uid);
  } catch (_) {
    return null;
  }
});

// Prompts for a specific library
final promptsByLibraryProvider =
    StreamProvider.family<List<Prompt>, String>((ref, libraryUid) {
  return ref.watch(promptRepositoryProvider).watchByLibrary(libraryUid);
});

class LibraryNotifier extends AsyncNotifier<List<Library>> {
  @override
  Future<List<Library>> build() async {
    return ref.watch(libraryRepositoryProvider).getAll();
  }

  Future<Library> createLibrary(String name) async {
    final lib = Library()
      ..uid = _uuid.v4()
      ..name = name
      ..isBuiltIn = false
      ..sortOrder = (state.valueOrNull?.length ?? 0)
      ..createdAt = DateTime.now();
    await ref.read(libraryRepositoryProvider).save(lib);
    return lib;
  }

  Future<void> renameLibrary(String uid, String newName) async {
    final lib = await ref.read(libraryRepositoryProvider).getByUid(uid);
    if (lib == null) return;
    lib.name = newName;
    await ref.read(libraryRepositoryProvider).save(lib);
  }

  Future<void> deleteLibrary(String uid) async {
    await ref.read(libraryRepositoryProvider).delete(uid);
  }
}

final libraryNotifierProvider =
    AsyncNotifierProvider<LibraryNotifier, List<Library>>(LibraryNotifier.new);

class PromptNotifier extends FamilyAsyncNotifier<List<Prompt>, String> {
  @override
  Future<List<Prompt>> build(String libraryUid) async {
    return ref.watch(promptRepositoryProvider).getByLibrary(libraryUid);
  }

  Future<void> addPrompt(String text) async {
    final prompts = await future;
    final prompt = Prompt()
      ..uid = _uuid.v4()
      ..text = text
      ..libraryUid = arg
      ..sortOrder = prompts.length
      ..isBuiltIn = false
      ..createdAt = DateTime.now();
    await ref.read(promptRepositoryProvider).save(prompt);
  }

  Future<void> updatePrompt(String uid, String newText) async {
    // Find the prompt by uid across this library
    final prompts = await future;
    final p = prompts.firstWhere((p) => p.uid == uid);
    p.text = newText;
    await ref.read(promptRepositoryProvider).save(p);
  }

  Future<void> deletePrompt(String uid) async {
    await ref.read(promptRepositoryProvider).delete(uid);
  }

  Future<void> reorderPrompts(List<Prompt> reordered) async {
    final updated = reordered.asMap().entries.map((e) {
      e.value.sortOrder = e.key;
      return e.value;
    }).toList();
    await ref.read(promptRepositoryProvider).saveAll(updated);
  }
}

final promptNotifierProvider =
    AsyncNotifierProviderFamily<PromptNotifier, List<Prompt>, String>(
        PromptNotifier.new);
