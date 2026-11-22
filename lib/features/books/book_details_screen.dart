import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/network_cover.dart';
import '../../models/book.dart';
import '../reservation/reservation_form_screen.dart';

class BookDetailsScreen extends StatelessWidget{
  const BookDetailsScreen({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context){
    final colors = Theme.of(context).colorScheme;
    final statusColor = book.isAvailable ? colors.tertiary : colors.error;

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details', style: AppTextStyles.heading),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
      ),
      body:ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: NetworkCover(url: book.coverUrl, width:112, height: 152),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(book.title, style: AppTextStyles.title),
          Text(
            book.author,
            style: AppTextStyles.body.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('Book ID: ${book.id}', style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.sm),
          Text(
            book.isAvailable? 'Available' : 'Borrowed',
            style: AppTextStyles.heading.copyWith(color:statusColor),
          ),
          Text(
            book.isAvailable
                ?'Expected return: Available now'
                :'Expected return: ${book.expectedReturn}',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.md),
          //ONGUN rezervasyon reserve formuna giden yer burasi sende.
          //Halletim. (ongun arda)

          AppButton(
            label: 'Reserve',
            onPressed: book.isAvailable
                ? () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ReservationFormScreen(book: book),
              ),
            )
                : null,
           ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(label: 'Follow for alerts', outlined: true, onPressed:(){}),
        ],
      ),
    );
  }
}