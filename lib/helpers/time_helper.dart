class TimeHelper {

  static String getPrettyTime(int time) {
    int hours = time ~/ 3600;
    int minutes = time ~/ 60 % 60;
    int seconds = time % 60;

    String prettyTime = minutes.toStringAsFixed(0) + 'm ' + seconds.toStringAsFixed(0) + 's';

    if(hours > 0) {
      prettyTime = hours.toStringAsFixed(0) + 'h ' + prettyTime;
    }

    return prettyTime;
  }
}