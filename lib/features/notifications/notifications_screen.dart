import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_books.dart';
import '../../models/book.dart';
import '../books/book_details_screen.dart';
import '../rooms/room_booking_format.dart';
import '../rooms/room_bookings.dart';
import '../rooms/room_reservations_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key, this.books = mockBooks, this.bookings});

  final Iterable<Book> books;
  final RoomBookings? bookings;

  @override
  Widget build(BuildContext context) {
    final roomBookings = bookings ?? demoRoomBookings;
    final dueBooks = books
        .where((book) => !book.isAvailable && book.dueDate != null)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: AppTextStyles.heading),
      ),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: roomBookings,
          builder: (context, _) {
            final upcoming = roomBookings.upcomingReservations(DateTime.now());
            final localizations = MaterialLocalizations.of(context);
            final colors = Theme.of(context).colorScheme;
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                if (dueBooks.isEmpty && upcoming.isEmpty)
                  const Text(
                    'You have no notifications.',
                    style: AppTextStyles.body,
                  ),
                for (final book in dueBooks)
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.menu_book, color: colors.secondary),
                      title: const Text(
                        'Book due date',
                        style: AppTextStyles.heading,
                      ),
                      subtitle: Text(
                        '${book.title} is due ${book.dueDate}.',
                        style: AppTextStyles.body,
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BookDetailsScreen(book: book),
                        ),
                      ),
                    ),
                  ),
                for (final booking in upcoming)
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.event_available,
                        color: colors.tertiary,
                      ),
                      title: const Text(
                        'Room booking',
                        style: AppTextStyles.heading,
                      ),
                      subtitle: Text(
                        '${booking.room.name}\n'
                        '${localizations.formatMediumDate(booking.startsAt)} · '
                        '${formatRoomTimeRange(context, booking.startsAt, booking.endsAt)}',
                        style: AppTextStyles.body,
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => RoomReservationDetailsScreen(
                            reservation: booking,
                            bookings: roomBookings,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
