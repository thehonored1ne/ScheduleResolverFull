import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/schedule_provider.dart';
import 'services/ai_schedule_service.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => AiScheduleService()),
      ],
      child: const ScheduleResolverApp(),
    ),
  );
}

class ScheduleResolverApp extends StatelessWidget {
  const ScheduleResolverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Schedule Resolver',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F0E8),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1A1A1A),
          secondary: Color(0xFFFFD700),
          error: Color(0xFFFF3B30),
          surface: Color(0xFFFFFFFF),
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w800, color: const Color(0xFF1A1A1A)),
          bodyLarge: GoogleFonts.ibmPlexMono(color: const Color(0xFF1A1A1A)),
          bodyMedium: GoogleFonts.ibmPlexMono(color: const Color(0xFF1A1A1A)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1A1A1A),
          foregroundColor: const Color(0xFFFFFFFF),
          elevation: 0,
          titleTextStyle: GoogleFonts.ibmPlexMono(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 2.0,
            color: const Color(0xFFFFFFFF),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFFFFFFF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Color(0xFF1A1A1A), width: 3.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Color(0xFF1A1A1A), width: 3.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Color(0xFFFFD700), width: 3.0),
          ),
          labelStyle: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1A1A),
            foregroundColor: const Color(0xFFFFD700),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: Color(0xFF1A1A1A), width: 3.0),
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ),
        useMaterial3: false,
      ),
      home: const DashboardScreen(),
    );
  }
}