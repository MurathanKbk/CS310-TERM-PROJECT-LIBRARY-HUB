import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/book_card.dart';
import '../../data/mock_books.dart';
import '../../models/book.dart';
import '../books/book_details_screen.dart';

/// Borrowed books as a list of cards. The X on a card returns the book
/// (removes it from the list) after a confirmation dialog.
class MyBorrowingsScreen extends StatefulWidget {
  const MyBorrowingsScreen({super.key});

  @override
  State<MyBorrowingsScreen> createState() => _MyBorrowingsScreenState();
}

class _MyBorrowingsScreenState extends State<MyBorrowingsScreen> {

  late final List<Book> _borrowed = mockBooks
      .where((book) => !book.isAvailable)
      .toList();

  Future<void> _confirmReturn(Book book) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Return book', style: AppTextStyles.heading),
        content: Text(
          'Mark "${book.title}" as returned?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Return'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _borrowed.remove(book));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${book.title}" returned.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Borrowings', style: AppTextStyles.heading),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
      ),
      body: _borrowed.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: AppSpacing.xl * 2,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('No borrowed books', style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Books you borrow will appear here.',
                style: AppTextStyles.body.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: _borrowed.length,
        separatorBuilder: (_, _) =>
        const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final book = _borrowed[index];
          return BookCard(
            book: book,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => BookDetailsScreen(book: book),
              ),
            ),
            onRemove: () => _confirmReturn(book),
          );
        },
      ),
    );
  }
}