import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/sceens/home.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 73, 210, 252),
  background: const Color.fromARGB(255, 3, 0, 185),
);

final theme = ThemeData().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.baiJamjureeTextTheme().copyWith(
    titleSmall: GoogleFonts.baiJamjuree(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.baiJamjuree(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.baiJamjuree(
      fontWeight: FontWeight.bold,
    ),
  ),
);
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}
