import 'package:event_poll/states/auth_state.dart';
import 'package:event_poll/states/polls_state.dart';
import 'package:event_poll/ui/login_page.dart';
import 'package:event_poll/ui/polls_page.dart';      // 👈 Nouvel import
import 'package:event_poll/ui/poll_page.dart';       // 👈 Nouvel import
import 'package:event_poll/ui/poll_edit_page.dart';  // 👈 Nouvel import
import 'package:event_poll/ui/signup_page.dart';     // 👈 Nouvel import

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'ui/app_scaffold.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthState(),
        ),
        ChangeNotifierProxyProvider<AuthState, PollsState>(
          create: (_) => PollsState(),
          update: (_, authState, pollsState) => pollsState!..setAuthToken(authState.token),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Poll',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      supportedLocales: const [Locale('fr')],
      locale: const Locale('fr'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      initialRoute: '/polls',
      routes: {
        '/polls': (context) => const AppScaffold(
              title: 'Événements',
              body: PollsPage(), // 👈 Remplacé !
            ),
        '/poll': (context) => const AppScaffold(
              title: 'Événement',
              body: PollPage(), // 👈 Remplacé !
            ),
        '/poll_edit': (context) => const AppScaffold(
              title: 'Modifier un événement',
              body: PollEditPage(), // 👈 Remplacé !
            ),
        '/login': (context) => const AppScaffold(
              title: 'Connexion',
              body: LoginPage(),
            ),
        '/signup': (context) => const AppScaffold(
              title: 'Inscription',
              body: SignupPage(), // 👈 Remplacé !
            ),
      },
    );
  }
}