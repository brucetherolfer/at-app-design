/// Build-time flavor constants. Injected via --dart-define.
/// AT flavor: flutter run --flavor at -t lib/main_at.dart --dart-define=FLAVOR=at
/// General:   flutter run --flavor general -t lib/main_general.dart --dart-define=FLAVOR=general
class AppFlavor {
  AppFlavor._();

  static const _flavor = String.fromEnvironment('FLAVOR', defaultValue: 'at');

  static bool get isAt      => _flavor == 'at';
  static bool get isGeneral => _flavor == 'general';

  static String get flavorName => _flavor;

  static String get appDisplayName =>
      isAt ? 'Alexander Technique' : 'Awareness Prompts';

  static String get bundleId =>
      isAt ? 'com.brucetherolfer.atapp' : 'com.brucetherolfer.atappgeneral';

  static String get defaultLibraryUid => 'builtin_all';
}
