import 'package:flutter/material.dart';
import 'core/theme/app_spacing.dart';
import 'core/theme/app_text_styles.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_button.dart';
import 'core/widgets/app_text_field.dart';
import 'core/widgets/book_card.dart';
import 'data/mock_books.dart';

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
                Text('Books', style: AppTextStyles.title),
                SizedBox(height: AppSpacing.md),
                for (final book in mockBooks) ...[
                  BookCard(book: book, onTap: () {}, onRemove: () {}),
                  SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}