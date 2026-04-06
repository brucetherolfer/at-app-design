import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/sequence.dart';
import 'repository_providers.dart';

const _uuid = Uuid();

final sequencesProvider = StreamProvider<List<Sequence>>((ref) {
  return ref.watch(sequenceRepositoryProvider).watchAll();
});

final sequenceByUidProvider = Provider.family<Sequence?, String>((ref, uid) {
  final seqs = ref.watch(sequencesProvider).valueOrNull ?? [];
  try {
    return seqs.firstWhere((s) => s.uid == uid);
  } catch (_) {
    return null;
  }
});

class SequenceNotifier extends AsyncNotifier<List<Sequence>> {
  @override
  Future<List<Sequence>> build() async {
    return ref.watch(sequenceRepositoryProvider).getAll();
  }

  Future<Sequence> createSequence(String name) async {
    final seq = Sequence()
      ..uid = _uuid.v4()
      ..name = name
      ..promptUids = []
      ..gapSeconds = 2
      ..isBuiltIn = false
      ..createdAt = DateTime.now();
    await ref.read(sequenceRepositoryProvider).save(seq);
    return seq;
  }

  Future<void> updateSequence(Sequence sequence) async {
    await ref.read(sequenceRepositoryProvider).save(sequence);
  }

  Future<void> deleteSequence(String uid) async {
    await ref.read(sequenceRepositoryProvider).delete(uid);
  }
}

final sequenceNotifierProvider =
    AsyncNotifierProvider<SequenceNotifier, List<Sequence>>(
        SequenceNotifier.new);
