import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/book_card.dart';
import '../../data/mock_books.dart';
import '../../models/book.dart';
import 'book_details_screen.dart';

enum _Filter { all, available, borrowed }

class BooksScreen extends StatefulWidget {
  const BooksScreen({
    super.key,
    this.initialQuery = '',
    this.showBackButton = false,
  });

  final String initialQuery;
  final bool showBackButton;

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  late final _search = TextEditingController(text: widget.initialQuery);
  _Filter _filter = _Filter.all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  // Aramaya ve secili filtreye uyan kitaplar.
  List<Book> get _results => mockBooks.where((book) {
    final q = _search.text.trim().toLowerCase();
    final matchesText =
        book.title.toLowerCase().contains(q) ||
        book.author.toLowerCase().contains(q);
    final matchesFilter = switch (_filter) {
      _Filter.all => true,
      _Filter.available => book.isAvailable,
      _Filter.borrowed => !book.isAvailable,
    };
    return matchesText && matchesFilter;
  }).toList();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final results = _results;

    return Scaffold(
      appBar: widget.showBackButton
          ? AppBar(title: const Text('Books', style: AppTextStyles.heading))
          : null,
      body: SafeArea(
        top: !widget.showBackButton,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            if (!widget.showBackButton) ...[
              const Text('Books', style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.md),
            ],
            AppTextField(
              label: 'Search',
              hint: 'Search by title or author',
              controller: _search,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final f in _Filter.values)
                  ChoiceChip(
                    label: Text(
                      f.name[0].toUpperCase() + f.name.substring(1),
                      style: AppTextStyles.caption,
                    ),
                    selected: _filter == f,
                    onSelected: (_) => setState(() => _filter = f),
                    selectedColor: colors.primaryContainer,
                    showCheckmark: false,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (results.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: Center(
                  child: Text('No books found', style: AppTextStyles.body),
                ),
              ),
            for (final book in results) ...[
              BookCard(
                book: book,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookDetailsScreen(book: book),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}
