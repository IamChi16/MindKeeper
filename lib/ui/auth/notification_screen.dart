import 'package:flutter/material.dart';
import 'package:reminder_app/services/notification_service.dart';
import 'package:reminder_app/widgets/date_time_selector.dart'; // Update with the correct path

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService _notificationService = NotificationService();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _scheduleNotification() async {
    final DateTime scheduledDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    if (scheduledDate.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scheduled date and time must be in the future'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    await _notificationService.scheduleNotification();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Notification scheduled successfully for ${scheduledDate.toString()}"),
          backgroundColor: Colors.greenAccent,
        ),
      );
    }
  }

  void _updateDateTime(DateTime date, TimeOfDay time) {
    setState(() {
      selectedDate = date;
      selectedTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _notificationService.showNotification,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text("Send Instant Notification"),
            ),
            SizedBox(height: 24),
            Text(
              "Schedule a notification",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            DateTimeSelector(
              initialDateTime: selectedDate,
              initialTime: selectedTime,
              onDateTimeChanged: _updateDateTime,
            ),
            ElevatedButton(
              onPressed: _scheduleNotification,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text("Schedule Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
