import 'package:flutter_jsonschema/models/Property.dart';

class Schema {
  String title;
  String type;
  String description;
  List<dynamic> required;
  List<Property> properties;

  Schema({
    this.title,
    this.type,
    this.description,
    this.required,
    this.properties,
  });

  factory Schema.fromJsonSchema(Map<String, dynamic> jsonSchema) {
    Schema newSchema = Schema(
      title: jsonSchema['title'],
      type: jsonSchema['type'],
      description: jsonSchema['description'],
      required: jsonSchema['required'],
    );
    newSchema.setProperties(jsonSchema['properties'], newSchema.required);
    print(newSchema.properties);
    return newSchema;
  }

  void setUiSchema(Map<String, dynamic> uiSchema) {
    uiSchema.forEach((key, data) {
      var props = properties.where((x) => x.id == key).toList();
      if (props.length > 0) {
        props.first = Property.fromUiSchema(props.first, uiSchema[key]);
      }
    });
  }

  setProperties(Map<String, dynamic> json, List<dynamic> requiredList) {
    List<Property> props = List<Property>();
    json.forEach((key, data) {
      bool required = true;
      if (requiredList.indexOf(key) == -1) {
        required = false;
      }
      props.add(
        Property(
          id: key,
          type: data['type'],
          title: data['title'],
          defaultValue: data['default'],
          minLength: data['minLength'],
          required: required,
        ),
      );
    });

    this.properties = props;
  }
}
