import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:troke/src/app.dart';

void main() {
  testWidgets('abre dashboard e navega para ordens', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const TorkeApp());
    await tester.pumpAndSettle();
    expect(find.text('Bom dia, Rafael!'), findsOneWidget);
    expect(find.text('Agenda de hoje'), findsOneWidget);
    await tester.tap(find.text('Serviços').first);
    await tester.pumpAndSettle();
    expect(find.text('Ordens de serviço'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
