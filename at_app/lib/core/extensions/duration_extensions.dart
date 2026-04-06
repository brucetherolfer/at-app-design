extension DurationFormat on Duration {
  /// e.g. "4:32" or "1:04:22"
  String toCountdownString() {
    final h = inHours;
    final m = inMinutes.remainder(60);
    final s = inSeconds.remainder(60);
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  /// e.g. "4m 32s"
  String toReadableString() {
    final m = inMinutes;
    final s = inSeconds.remainder(60);
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }
}
