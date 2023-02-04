


extension TimeFormaterOnDuration on Duration {
  String toFormattedString() {
    final buf = StringBuffer();
    if (inHours > 0) {
      buf.write('$inHours');
      buf.write(':');
    }
    final minutes = inMinutes % Duration.minutesPerHour;
    if (minutes > 9) {
      buf.write('$minutes');
    } else {
      buf.write('0');
      buf.write('$minutes');
    }
    buf.write(':');
    buf.write(
        (inSeconds % Duration.secondsPerMinute).toString().padLeft(2, '0'));
    return buf.toString();
  }


}
