import 'package:intl/intl.dart';

class PointsService {

  static int calculateCurrantStreak(List<String> streakDays) {
    String today = formatStreakDate(DateTime.now());
    String yesterday = formatStreakDate(DateTime.now().subtract(const Duration(days: 1)));

    if(streakDays.length == 1 && [yesterday, today].contains(streakDays[0])){
      return 1;
    }
    if (!streakDays.contains(yesterday)) {
      return 0;
    }
    return streakDays.length;
  }

  static bool isActiveToday(List<String> streakDays) {
    DateTime today = DateTime.now();
    return streakDays.contains(formatStreakDate(today));
  }

  static String getCurrantDate() {
    DateTime now = DateTime.now();
    return formatStreakDate(now);
  }

  static String formatStreakDate(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

}
