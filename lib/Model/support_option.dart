class SupportOption {
  final String value;
  final String label;

  SupportOption({
    required this.value,
    required this.label,
  });

  factory SupportOption.fromJson(Map<String, dynamic> json) {
    return SupportOption(
      value: json['value'],
      label: json['label'],
    );
  }
}
