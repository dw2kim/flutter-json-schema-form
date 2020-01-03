class Property {
  String id;
  String type;
  String title;
  dynamic defaultValue;
  bool required;
  int minLength;
  bool autoFocus;
  String emptyValue;
  String description;
  String help;
  String widget;
  Options options;

  Property({
    this.id,
    this.type,
    this.title,
    this.defaultValue,
    this.required,
    this.minLength,
    this.autoFocus,
    this.emptyValue,
    this.description,
    this.help,
    this.options,
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
      switch (key) {
        case "ui:autofocus":
          property.autoFocus = data as bool;
          break;
        case "ui:emptyValue":
          property.emptyValue = data as String;
          break;
        case "ui:title":
          property.title = data as String;
          break;
        case "ui:description":
          property.description = data as String;
          break;
        case "ui:help":
          property.help = data as String;
          break;
        case "ui:widget":
          property.widget = data as String;
          break;
        case "ui:options":
          property.options = Options.fromJson(data);
          break;
        default:
          break;
      }
    });

    return property;
  }
}

class Options {
  String inputType;

  Options({
    this.inputType,
  });

  factory Options.fromJson(Map<String, dynamic> json) {
    Options options =Options();

    options.inputType = json["inputType"];

    return options;
  }
}
