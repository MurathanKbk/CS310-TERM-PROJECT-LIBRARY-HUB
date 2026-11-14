import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/book_card.dart';
import '../../core/widgets/network_cover.dart';
import '../../data/mock_books.dart';
import '../../models/book.dart';
import '../books/book_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Kopya liste: X'e basinca sadece ekrandaki liste degisir.
  late final List<Book> _dueSoon =
  mockBooks.where((book) => !book.isAvailable).toList();

  void _remove(Book book) => setState(() => _dueSoon.remove(book));

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Text(
              'LibraryHub',
              style: AppTextStyles.title.copyWith(color: colors.secondary),
            ),
            const SizedBox(height: AppSpacing.md),
            const AppTextField(label: 'Search', hint: 'Search books...'),
            const SizedBox(height: AppSpacing.lg),
            Text('Due soon', style: AppTextStyles.heading),
            const SizedBox(height: AppSpacing.sm),
            if (_dueSoon.isEmpty)
              Text('Nothing due soon', style: AppTextStyles.body),
            for (final book in _dueSoon) ...[
              BookCard(
                book: book,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
                ),
                onRemove: () => _remove(book),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.md),
            Text("Today's room booking", style: AppTextStyles.heading),
            const SizedBox(height: AppSpacing.sm),
            // Cavid bura sende, reservation modelinden gelen gercek karti buraya koyman lazim
            Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              color: colors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                side: BorderSide(color: colors.outline),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Row(
                  children: [
                    const NetworkCover(url: null, label: 'Room'),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Study Room 3',
                            style: AppTextStyles.heading.copyWith(fontSize: 16)),
                        Text('14:00 - 16:00',
                            style: AppTextStyles.body
                                .copyWith(color: colors.onSurfaceVariant)),
                        Text('Confirmed',
                            style: AppTextStyles.caption
                                .copyWith(color: colors.tertiary)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}