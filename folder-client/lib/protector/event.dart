class Event {
  final String name;
  final String time;
  final String date;
  bool? isChecked;
  Event({
    required this.name,
    required this.time,
    required this.date,
    this.isChecked,
  });

  factory Event.fromJson(Map<String?, dynamic> json) {
    return Event(
      name: json['content'],
      time: json['calendarTime'],
      date: json['calendarDate'],
      isChecked: json['calendarCheck'] ?? false,
    );
  }
}
