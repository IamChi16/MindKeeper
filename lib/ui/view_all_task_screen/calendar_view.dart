import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../app/app_export.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late Map<DateTime, List<dynamic>> _events;
  late List<dynamic> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedEvents = [];
    _loadEvents();
  } 

  Future<void> _loadEvents() async {
    // Load events from database
    FirebaseFirestore.instance.collection('tasks').snapshots().listen((snapshot){
      Map<DateTime, List<dynamic>> events = {};
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        DateTime duedate = (data['duedate'] as Timestamp).toDate();
        if (events[duedate] == null) {
          events[duedate] = [];
        }
        events[duedate]!.add(data);
      }
      setState(() {
        _events = events;
      });
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _selectedEvents = _events[selectedDay] ?? [];
    });
  }

  void _onCalendarFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
              iconSize: 20,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: appTheme.whiteA700,
              )),
          title: Text(
            "Calendar",
            style: appStyle(18, Colors.white, FontWeight.w600),
          ),
          centerTitle: true,
        ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2021, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: (day) => _events[day] ?? [],
            // startingDayOfWeek: StartingDayOfWeek.monday,
            // calendarStyle: CalendarStyle(
            //   selectedDecoration: BoxDecoration(
            //     color: appTheme.blackA700,
            //     shape: BoxShape.circle,
            //   ),
            //   todayDecoration: BoxDecoration(
            //     color: appTheme.blackA700,
            //     shape: BoxShape.circle,
            //   ),
            //   selectedTextStyle: TextStyle(color: appTheme.whiteA700),
            //   todayTextStyle: TextStyle(color: appTheme.whiteA700),
            // ),
            // headerStyle: HeaderStyle(
            //   formatButtonVisible: false,
            //   titleCentered: true,
            //   titleTextStyle: appStyle(18, appTheme.whiteA700, FontWeight.w600),
            //   leftChevronIcon: Icon(Icons.arrow_back_ios_new_rounded, color: appTheme.whiteA700),
            //   rightChevronIcon: Icon(Icons.arrow_forward_ios_rounded, color: appTheme.whiteA700),
            // ),
            onDaySelected: _onDaySelected,
            onFormatChanged: _onCalendarFormatChanged,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedEvents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_selectedEvents[index]['title']),
                  subtitle: Text(_selectedEvents[index]['description']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}