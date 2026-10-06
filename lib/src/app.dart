import 'package:flutter/material.dart';

import 'data/app_state.dart';
import 'theme/app_theme.dart';
import 'ui/app_shell.dart';

class TorkeApp extends StatefulWidget {
  const TorkeApp({super.key});
  @override
  State<TorkeApp> createState() => _TorkeAppState();
}

class _TorkeAppState extends State<TorkeApp> {
  final AppState state = AppState.seeded();
  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppScope(
    notifier: state,
    child: MaterialApp(
      title: 'Torke',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppShell(),
    ),
  );
}
