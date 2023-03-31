class Fill {
  final int? fillId;
  final String fillName;
  final String fillTime;
  late bool isChecked;

  Fill({
    this.fillId,
    required this.fillName,
    required this.fillTime,
    bool? isChecked,
  }) : isChecked = isChecked ?? false;

  factory Fill.fromJson(Map<String, dynamic> json) {
    return Fill(
      fillId: json['fillId'],
      fillName: json['fillName'],
      fillTime: json['fillTime'],
      isChecked: json['fillCheck'] ?? false,
    );
  }
}
