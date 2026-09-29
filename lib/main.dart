import 'package:flutter/material.dart';

import 'data/patient_store.dart';
import 'screens/home_screen.dart';
import 'screens/lock_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await PatientStore.open();
  runApp(ClinicRegisterApp(store: store));
}

class ClinicRegisterApp extends StatelessWidget {
  const ClinicRegisterApp({super.key, required this.store, this.requireLock = true});
  final PatientStore store;
  final bool requireLock;

  @override
  Widget build(BuildContext context) {
    ThemeData theme(Brightness b) => ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.teal,
          brightness: b,
        );
    return MaterialApp(
      title: 'Clinic Register',
      debugShowCheckedModeBanner: false,
      theme: theme(Brightness.light),
      darkTheme: theme(Brightness.dark),
      home: requireLock
          ? LockScreen(child: HomeScreen(store: store))
          : HomeScreen(store: store),
    );
  }
}
