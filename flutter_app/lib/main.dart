import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'state/app_state.dart';

void main() {
  runApp(const QseDashboardApp());
}

class QseDashboardApp extends StatelessWidget {
  const QseDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..load(),
      child: MaterialApp(
        title: 'Tableau de bord QSE',
        debugShowCheckedModeBanner: false,
        themeMode: context.watch<AppState>().themeMode,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF243B53),
          scaffoldBackgroundColor: const Color(0xFFF7FAFC),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF243B53),
          brightness: Brightness.dark,
        ),
        home: Consumer<AppState>(
          builder: (context, state, _) {
            if (!state.loaded) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            return const HomeScreen();
          },
        ),
      ),
    );
  }
}
