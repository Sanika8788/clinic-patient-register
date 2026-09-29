import 'package:flutter/material.dart';
import 'package:clinic_register/data/patient_store.dart';
import 'package:clinic_register/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('add, search and delete a patient', (tester) async {
    await tester.pumpWidget(ClinicRegisterApp(store: MemoryPatientStore(), requireLock: false));
    await tester.pumpAndSettle();
    expect(find.text('No patients yet. Tap + to add.'), findsOneWidget);

    await tester.tap(find.text('Add patient'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Full name'), 'Asha Patil');
    await tester.enterText(find.widgetWithText(TextFormField, 'Age'), '34');
    await tester.enterText(find.widgetWithText(TextFormField, 'Phone'), '9876543210');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Asha Patil'), findsOneWidget);

    await tester.enterText(find.byType(SearchBar), 'zzz');
    await tester.pumpAndSettle();
    expect(find.text('Asha Patil'), findsNothing);
  });

  testWidgets('form rejects invalid phone', (tester) async {
    await tester.pumpWidget(ClinicRegisterApp(store: MemoryPatientStore(), requireLock: false));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add patient'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Full name'), 'Asha');
    await tester.enterText(find.widgetWithText(TextFormField, 'Age'), '30');
    await tester.enterText(find.widgetWithText(TextFormField, 'Phone'), '123');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a 10-digit number'), findsOneWidget);
  });
}
