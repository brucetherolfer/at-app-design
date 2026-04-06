import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/prompt.dart';
import '../models/library.dart';
import '../models/sequence.dart';
import '../models/blackout_window.dart';
import '../models/app_settings.dart';

class IsarService {
  static Isar? _instance;

  static Future<Isar> open() async {
    if (_instance != null && _instance!.isOpen) return _instance!;
    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [
        PromptSchema,
        LibrarySchema,
        SequenceSchema,
        BlackoutWindowSchema,
        AppSettingsSchema,
      ],
      directory: dir.path,
    );
    return _instance!;
  }

  static Isar get instance {
    assert(_instance != null && _instance!.isOpen, 'IsarService not initialized');
    return _instance!;
  }
}
