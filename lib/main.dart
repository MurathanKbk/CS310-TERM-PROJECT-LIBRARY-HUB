import 'package:flutter/material.dart';
import 'core/theme/app_spacing.dart';
import 'core/theme/app_text_styles.dart';
import 'core/theme/app_theme.dart';

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
      home: const Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LibraryHub', style: AppTextStyles.title),
                Text('Theme test', style: AppTextStyles.body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}