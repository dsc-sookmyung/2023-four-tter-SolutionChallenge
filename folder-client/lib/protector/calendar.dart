import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  final OnDaySelected onDaySelected; //날짜 선택시 실행할 함수
  final DateTime selectedDate; //선택된 날짜
  const CalendarWidget({
    required this.onDaySelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          onDaySelected: onDaySelected,
          //날짜 선택시 실행할 함수
          selectedDayPredicate: ((day) =>
              day.year == selectedDate.year &&
              day.month == selectedDate.month &&
              day.day == selectedDate.day),
          focusedDay: DateTime.now(),
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime(2023, 12, 31),
          locale: 'ko-KR',

          //style the calendar
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            todayDecoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor, shape: BoxShape.circle),
          ),
        ),
      ],
    );
  }
}
