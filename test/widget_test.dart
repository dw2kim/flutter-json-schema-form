import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_jsonschema/main.dart';

void main() {
  testWidgets('todo', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
  });
}
