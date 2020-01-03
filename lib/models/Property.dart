class Property {
  String id;
  String type;
  String title;
  dynamic defaultValue;
  bool required;
  int minLength;
  bool autoFocus;
  String emptyValue;

  Property({
    this.id,
    this.type,
    this.title,
    this.defaultValue,
    this.required,
    this.minLength,
    this.autoFocus,
    this.emptyValue,
  });

  factory Property.fromJsonSchema(
      String propertyId, Map<String, dynamic> jsonSchema) {
    return Property(
      id: propertyId,
      type: jsonSchema['type'],
      title: jsonSchema['title'],
      defaultValue: jsonSchema['default'],
      minLength: jsonSchema['minLength'],
    );
  }

  factory Property.fromUiSchema(Property prop, Map<String, dynamic> uiSchema) {
    Property property = prop;

    uiSchema.forEach((key, data) {
      switch(key) {
        case "ui:autofocus":
          property.autoFocus = data as bool;
          break;
        case "ui:emptyValue":
          property.emptyValue = data as String;
          break;
        case "ui:title":
          property.title = data as String;
          break;

        default:
          break;
      }
    });

    return property;
  }
}
