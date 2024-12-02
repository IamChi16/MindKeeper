import 'package:flutter/material.dart';

class DateTimeSelector extends StatefulWidget {
  final DateTime initialDateTime;
  final TimeOfDay initialTime; 
  final Function(DateTime, TimeOfDay) onDateTimeChanged;

  const DateTimeSelector({required this.initialDateTime, required this.initialTime, required this.onDateTimeChanged});

  @override
  _DateTimeSelectorState createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends State<DateTimeSelector> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDateTime;
    selectedTime = widget.initialTime;
  }

  // Removed duplicate build method
  
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      widget.onDateTimeChanged(picked, selectedTime);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      widget.onDateTimeChanged(selectedDate, picked);
    }
  }
  @override
  Widget build (BuildContext context){
    return Row(
      children: [
        Expanded(child: OutlinedButton.icon(
          onPressed: () => _selectDate(context),
          icon: const Icon(Icons.calendar_today),
          label: Text(
            'Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
        
        )),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
          onPressed: () => _selectTime(context),
          icon: const Icon(Icons.access_time),
          label: Text(
            'Time: ${selectedTime.format(context)}'),
        ),
    )],
    );
  }
  
}