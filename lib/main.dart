import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


const String prefIntervalKey = 'reminder_interval_minutes';
const String prefMessageKey = 'reminder_message';


// Unique alarm id
const int alarmId = 0;


Future<void> showNotification(String message) async {
const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
'reminder_channel',
' Reminders',
channelDescription: 'Channel for custom reminders',
importance: Importance.max,
priority: Priority.high,
ticker: 'ticker',
);
const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
await flutterLocalNotificationsPlugin.show(0, 'Reminder', message, platformChannelSpecifics);
}


void alarmCallback() async {
// This runs in background isolate
final prefs = await SharedPreferences.getInstance();
final message = prefs.getString(prefMessageKey) ?? 'Padhne baith ja saale!';
await showNotification(message);
}


Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();


// init notifications
const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
await flutterLocalNotificationsPlugin.initialize(initializationSettings);


// init Android alarm manager
await AndroidAlarmManager.initialize();


runApp(MyApp());
}


class MyApp extends StatefulWidget {
@override
State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
int _intervalMinutes = 60;
String _message = 'Padhne baith ja saale!';
bool _isRunning = false;


@override
void initState() {
}