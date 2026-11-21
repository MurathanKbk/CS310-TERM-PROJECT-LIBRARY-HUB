import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/book_card.dart';
import '../../data/mock_books.dart';
import '../../models/book.dart';
import '../books/book_details_screen.dart';
import '../books/books_screen.dart';
import '../notifications/notifications_screen.dart';
import '../rooms/room_booking_format.dart';
import '../rooms/room_bookings.dart';
import '../rooms/room_reservation_card.dart';
import '../rooms/room_reservations_screen.dart';
import '../rooms/rooms_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.bookings});

  final RoomBookings? bookings;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Kopya liste: X'e basinca sadece ekrandaki liste degisir.
  late final List<Book> _dueSoon = mockBooks
      .where((book) => !book.isAvailable)
      .toList();

  void _remove(Book book) => setState(() => _dueSoon.remove(book));

  void _openBooks(String query) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) =>
          BooksScreen(initialQuery: query.trim(), showBackButton: true),
    ),
  );

  void _openNotifications(RoomBookings bookings) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => NotificationsScreen(books: _dueSoon, bookings: bookings),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final roomBookings = widget.bookings ?? demoRoomBookings;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/libraryhub_logo.png',
                  width: AppSpacing.xl,
                  excludeFromSemantics: true,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'LibraryHub',
                    style: AppTextStyles.title.copyWith(
                      color: colors.secondary,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Notifications',
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => _openNotifications(roomBookings),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ListenableBuilder(
              listenable: roomBookings,
              builder: (context, _) {
                final now = DateTime.now();
                final upcoming = roomBookings.upcomingReservations(now);
                final today = upcoming.where(
                  (booking) => DateUtils.isSameDay(booking.startsAt, now),
                );
                final due = _dueSoon.where((book) => book.dueDate != null);
                final booking = today.firstOrNull;
                final book = due.firstOrNull;
                if (booking == null && book == null) {
                  return const SizedBox.shrink();
                }
                final count = upcoming.length + due.length;
                final reminder = booking == null
                    ? '${book!.title} · Due ${book.dueDate}'
                    : '${booking.room.name} · ${formatRoomTimeRange(context, booking.startsAt, booking.endsAt)}';
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      title: Text(
                        booking == null ? 'Book reminder' : 'Room reminder',
                        style: AppTextStyles.heading,
                      ),
                      subtitle: Text(
                        count > 1 ? '$reminder\n+${count - 1} more' : reminder,
                        style: AppTextStyles.body,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openNotifications(roomBookings),
                    ),
                  ),
                );
              },
            ),
            AppTextField(
              label: 'Search',
              hint: 'Search books...',
              onSubmitted: _openBooks,
            ),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: colors.secondary,
                  ),
                  onPressed: () => _openBooks(''),
                  child: const Text('Browse Books', style: AppTextStyles.body),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: colors.secondary,
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => RoomsScreen(
                        bookings: roomBookings,
                        showBackButton: true,
                      ),
                    ),
                  ),
                  child: const Text('Browse Rooms', style: AppTextStyles.body),
                ),
              ],
            ),
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
                  MaterialPageRoute(
                    builder: (_) => BookDetailsScreen(book: book),
                  ),
                ),
                onRemove: () => _remove(book),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.md),
            Text("Today's room booking", style: AppTextStyles.heading),
            const SizedBox(height: AppSpacing.sm),
            ListenableBuilder(
              listenable: roomBookings,
              builder: (context, _) {
                final today = DateTime.now();
                final reservations =
                    roomBookings.reservations
                        .where(
                          (booking) =>
                              DateUtils.isSameDay(booking.startsAt, today),
                        )
                        .toList()
                      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (reservations.isEmpty)
                      const Text(
                        'No room bookings today.',
                        style: AppTextStyles.body,
                      ),
                    for (final reservation in reservations) ...[
                      RoomReservationCard(
                        reservation: reservation,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => RoomReservationDetailsScreen(
                              reservation: reservation,
                              bookings: roomBookings,
                            ),
                          ),
                        ),
                        onCancel: () => confirmRoomCancellation(
                          context,
                          roomBookings,
                          reservation,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
