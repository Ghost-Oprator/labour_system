import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';  // Add this line
import 'package:intl/intl.dart';  // Add this line


class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}
class Event {
  final String description;
  final double expense;

  Event(this.description, this.expense);
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Expense Tracker'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _showAddEventDialog(selectedDay);
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog(DateTime selectedDate) {
    String description = '';
    double expense = 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Event - ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) => description = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Expense'),
              keyboardType: TextInputType.number,
              onChanged: (value) => expense = double.tryParse(value) ?? 0.0,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (description.isNotEmpty) {
                setState(() {
                  _events.update(
                    selectedDate,
                    (value) => [...value, Event(description, expense)],
                    ifAbsent: () => [Event(description, expense)],
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}