import 'package:flutter/material.dart';
import 'core/theme/app_spacing.dart';
import 'core/theme/app_text_styles.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_button.dart';

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
      home:Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LibraryHub', style: AppTextStyles.title),
                SizedBox(height: AppSpacing.md),
                AppButton(label: 'Continue', onPressed: () {}),
                SizedBox(height: AppSpacing.sm),
                AppButton(label: 'Continue', onPressed: null),
                SizedBox(height: AppSpacing.sm),
                AppButton(label: 'Cancel', outlined: true, onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}