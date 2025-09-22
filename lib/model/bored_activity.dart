class BoredActivity {
  final String activity;
  final String type;
  final double availability;   // + 新增
  final String accessibility;  // <- 改成 String

  BoredActivity({
    required this.activity,
    required this.type,
    required this.availability,
    required this.accessibility,
  });

  factory BoredActivity.fromJson(Map<String, dynamic> json) {
    return BoredActivity(
      activity: json['activity']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      availability: (json['availability'] is num)
          ? (json['availability'] as num).toDouble()
          : 0.0,
      // 兼容數字/字串兩種情況，全部轉成文字顯示
      accessibility: (json['accessibility'] == null)
          ? ''
          : (json['accessibility'] is num)
          ? (json['accessibility'] as num).toString()
          : json['accessibility'].toString(),
    );
  }
}
