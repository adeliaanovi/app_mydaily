import 'package:flutter_test/flutter_test.dart';
import 'package:app_mydaily/main.dart';

void main() {
  test('MyDailyApp dapat dibuat', () {
    const app = MyDailyApp();

    expect(app, isA<MyDailyApp>());
  });
}