class Property {
  String id;
  String type;
  String title;
  dynamic defaultValue;
  bool required;
  int minLength;

  Property({
    this.id,
    this.type,
    this.title,
    this.defaultValue,
    this.required,
    this.minLength,
  });

  factory Property.fromJson(String propertyId, Map<String, dynamic> json) {
    return Property(
      id: propertyId,
      type: json['type'],
      title: json['title'],
      defaultValue: json['default'],
      minLength: json['minLength'],
    );
  }
}
