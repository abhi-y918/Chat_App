
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'SCREEN/auth.dart';
import 'SCREEN/chat.dart';
import 'SCREEN/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fjuvqnuwqvvtqzhlqzae.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqdXZxbnV3cXZ2dHF6aGxxemFlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI2OTMzNDQsImV4cCI6MjA3ODI2OTM0NH0.SkOfHNVzt098lFVZai-eMhp-zAB6LInJkMckXp-g2ms',
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 63, 17, 177),
        ),
      ),
      home: StreamBuilder<AuthState>(
        stream: supabase.auth.onAuthStateChange,
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return const splashscreen();
          }

          final session = snapshot.data!.session;

          if (session != null) {
            return const chatscreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
