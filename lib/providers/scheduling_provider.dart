import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/utils/background_service.dart';
import 'package:restaurant_app/utils/date_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulingProvider with ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  SchedulingProvider() {
    _getPref();
  }

  Future<bool> scheduledNews() async {
    _isScheduled = !_isScheduled;
    var prefs = await SharedPreferences.getInstance();

    if (_isScheduled) {
      _isScheduled = true;
      await prefs.setBool('isScheduled', true);
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      _isScheduled = false;
      prefs.setBool('isScheduled', false);
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }

  void _getPref() async {
    var prefs = await SharedPreferences.getInstance();
    _isScheduled = prefs.getBool('isScheduled') ?? false;
    notifyListeners();
  }
}
