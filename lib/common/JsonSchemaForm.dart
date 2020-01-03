import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_jsonschema/bloc/SchemaParser.dart';
import 'package:flutter_jsonschema/common/CheckboxFormField.dart';
import 'package:flutter_jsonschema/models/Property.dart';
import 'package:flutter_jsonschema/models/Schema.dart';

class JsonSchemaForm extends StatefulWidget {
  final Schema schema;
  final SchemaParser parser;

  JsonSchemaForm({@required this.schema, this.parser});

  @override
  State<StatefulWidget> createState() {
    return _JsonSchemaFormState(schema: schema, parser: parser);
  }
}

typedef JsonSchemaFormSetter<T> = void Function(T newValue);

class _JsonSchemaFormState extends State<JsonSchemaForm> {
  final Schema schema;
  final _formKey = GlobalKey<FormState>();
  final SchemaParser parser;

  _JsonSchemaFormState({@required this.schema, this.parser});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            schema.title != null ? schema.title : '',
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Container(
                          child: Text(
                            schema.description != null
                                ? schema.description
                                : '',
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: schema.properties.map<Widget>((item) {
                        return getWidget(item);
                      }).toList(),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Map<String, dynamic> data = Map<String, dynamic>();
                        data['submit'] = true;
                        parser.jsonDataAdd.add(data);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
              stream: parser.submitData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data);
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }

  Widget getWidget(Property properties) {
    switch (properties.type) {
      case 'string':
        return getTextField(properties);
      case 'boolean':
        return getCheckBox(properties);
      default:
        return Container();
    }
  }

  Widget getTextField(Property properties) {
    return StreamBuilder(
      stream: parser.formData[properties.id],
      builder: (context, snapshot) {
        return Container(
          child: TextFormField(
            autofocus: (properties.autoFocus ?? false),
            initialValue: properties.defaultValue ?? '',
            onSaved: (value) {
              Map<String, dynamic> data = Map<String, dynamic>();
              data[properties.id] = value;
              parser.jsonDataAdd.add(data);
            },
            autovalidate: true,
            onChanged: (String value) {
              if (properties.emptyValue != null && value.isEmpty) {
                return properties.emptyValue;
              }

              return value;
            },
            validator: (String value) {
              if (properties.required && value.isEmpty) {
                return 'Required';
              }
              if (properties.minLength != null &&
                  value.isNotEmpty &&
                  value.length <= properties.minLength) {
                return 'should NOT be shorter than ${properties.minLength} characters';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: properties.required
                  ? properties.title + ' *'
                  : properties.title,
            ),
          ),
        );
      },
    );
  }

  Widget getCheckBox(Property properties) {
    return StreamBuilder(
      stream: parser.formData[properties.id],
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CheckboxFormField(
            autoValidate: true,
            initialValue: snapshot.data,
            title: properties.title,
            validator: (bool val) {
              if (properties.required) {
                if (!val) {
                  return "Required";
                }
              }
              return null;
            },
            onSaved: (bool val) {},
            onChange: (val) {
              Map<String, dynamic> data = Map<String, dynamic>();
              data[properties.id] = val;
              parser.jsonDataAdd.add(data);
              return;
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    parser.dispose();
  }
}
