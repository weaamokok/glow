import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:glow/resources/resources.dart';

void main() {
  test('images assets test', () {
    expect(File(Images.emptyActions).existsSync(), isTrue);
    expect(File(Images.emptyCalender).existsSync(), isTrue);
    expect(File(Images.emptySchdule).existsSync(), isTrue);
    expect(File(Images.logo).existsSync(), isTrue);
  });
}
