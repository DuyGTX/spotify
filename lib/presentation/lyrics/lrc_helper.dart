class LyricLine {
  final Duration time;
  final String text;

  LyricLine(this.time, this.text);
}

List<LyricLine> parseLrc(String lrcContent) {
  final lines = lrcContent.split('\n');
  final result = <LyricLine>[];

  final regExp = RegExp(r"\[(\d+):(\d+\.\d+)\](.*)");

  for (final line in lines) {
    final match = regExp.firstMatch(line);
    if (match != null) {
      final minute = int.parse(match.group(1)!);
      final second = double.parse(match.group(2)!);
      final text = match.group(3)!.trim();

      final duration = Duration(
        minutes: minute,
        milliseconds: (second * 1000).toInt(),
      );
      result.add(LyricLine(duration, text));
    }
  }

  return result;
}
