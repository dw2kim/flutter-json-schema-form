import 'package:flutter/material.dart';
import 'package:flutter_jsonschema/bloc/SchemaParser.dart';
import 'package:flutter_jsonschema/common/JsonSchemaForm.dart';
import 'package:flutter_jsonschema/models/Schema.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Flutter JsonSchema Demo';
    SchemaParser parser = SchemaParser();
    parser.getTestSchema();

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: StreamBuilder<Schema>(
          stream: parser.jsonSchema,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return JsonSchemaForm(
                schema: snapshot.data,
                parser: parser,
              );
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}



