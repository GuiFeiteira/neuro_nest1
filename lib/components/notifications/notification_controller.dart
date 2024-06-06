import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController{


  @pragma("vm:entry-point")
  static Future<void> onNotificationCreate(
      ReceivedNotification receivedNotification )async{

  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplay (
      ReceivedNotification receivedNotification)async{

  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDismiss(
      ReceivedAction receivedAction)async{

  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceive(
      ReceivedAction receivedAction)async{

  }
}