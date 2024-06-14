import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:intl/intl.dart';

class NotificationController {

  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      null, // Nome do ícone de notificação
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Color(0xFF9D50DD),
          importance: NotificationImportance.High,
        )
      ],
      debug: true,
    );
  }

  static Future<void> scheduleNotification(String name, String time, String frequency, {List<String>? daysOfWeek}) async {
    final now = DateTime.now();
    final format = DateFormat('HH:mm');
    final timeOfDay = format.parse(time);
    final scheduledTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);

    if (frequency == 'Diariamente') {
      await _scheduleDailyNotification(name, scheduledTime);
    } else if (frequency == 'Alguns Dias da Semana' && daysOfWeek != null) {
      await _scheduleWeeklyNotification(name, scheduledTime, daysOfWeek);
    } else {
      // Para notificações "As Needed" ou casos não especificados
      await _scheduleSingleNotification(name, scheduledTime);
    }
  }

  static Future<void> _scheduleDailyNotification(String name, DateTime scheduledTime) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: 'Hora de tomar seu medicamento',
        body: 'Está na hora de tomar o $name',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: scheduledTime.hour,
        minute: scheduledTime.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );

    // Print de confirmação no console
    print('Notificação diária criada para $name às ${scheduledTime.hour}:${scheduledTime.minute}');
  }

  static Future<void> _scheduleWeeklyNotification(String name, DateTime scheduledTime, List<String> daysOfWeek) async {
    final dayMap = {
      'Seg': DateTime.monday,
      'Ter': DateTime.tuesday,
      'Qua': DateTime.wednesday,
      'Qui': DateTime.thursday,
      'Sex': DateTime.friday,
      'Sáb': DateTime.saturday,
      'Dom': DateTime.sunday,
    };

    for (String day in daysOfWeek) {
      int weekday = dayMap[day]!;
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          channelKey: 'basic_channel',
          title: 'Hora de tomar seu medicamento',
          body: 'Está na hora de tomar o $name',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar(
          weekday: weekday,
          hour: scheduledTime.hour,
          minute: scheduledTime.minute,
          second: 0,
          millisecond: 0,
          repeats: true,
        ),
      );

      // Print de confirmação no console
      print('Notificação semanal criada para $name às ${scheduledTime.hour}:${scheduledTime.minute} no dia $day');
    }
  }

  static Future<void> _scheduleSingleNotification(String name, DateTime scheduledTime) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: 'Hora de tomar seu medicamento',
        body: 'Está na hora de tomar o $name',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduledTime),
    );

    // Print de confirmação no console
    print('Notificação única criada para $name às ${scheduledTime.hour}:${scheduledTime.minute}');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreate(ReceivedNotification receivedNotification) async {

  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplay(ReceivedNotification receivedNotification) async {
    // Implementação opcional
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDismiss(ReceivedAction receivedAction) async {
    // Implementação opcional
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceive(ReceivedAction receivedAction) async {
    // Implementação opcional
  }
}
