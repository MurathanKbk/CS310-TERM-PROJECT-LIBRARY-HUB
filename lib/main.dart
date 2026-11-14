import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/books/books_screen.dart';
import 'features/home/home_screen.dart';

void main(){
  runApp(const LibraryHubApp());
}

class LibraryHubApp extends StatelessWidget {
  const LibraryHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LibraryHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}