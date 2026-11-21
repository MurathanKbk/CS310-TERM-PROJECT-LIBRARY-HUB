import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/network_cover.dart';
import '../../models/reservation.dart';
import 'room_booking_format.dart';
import 'room_bookings.dart';
import 'room_reservation_card.dart';

Future<bool> confirmRoomCancellation(
  BuildContext context,
  RoomBookings bookings,
  Reservation reservation,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Cancel room reservation?',
        style: AppTextStyles.heading,
      ),
      content: Text('Cancel your booking for ${reservation.room.name}?'),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Keep Booking'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
  if (confirmed != true) return false;
  bookings.cancel(reservation);
  return true;
}

class MyRoomReservationsScreen extends StatelessWidget {
  const MyRoomReservationsScreen({super.key, this.bookings});

  final RoomBookings? bookings;

  @override
  Widget build(BuildContext context) {
    final roomBookings = bookings ?? demoRoomBookings;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Room Reservations', style: AppTextStyles.heading),
      ),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: roomBookings,
          builder: (context, _) {
            final reservations = roomBookings.reservations.toList()
              ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                if (reservations.isEmpty)
                  const Text(
                    'No room reservations yet.',
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
      ),
    );
  }
}

class RoomReservationDetailsScreen extends StatelessWidget {
  const RoomReservationDetailsScreen({
    super.key,
    required this.reservation,
    required this.bookings,
  });

  final Reservation reservation;
  final RoomBookings bookings;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final date = MaterialLocalizations.of(context)
        .formatFullDate(reservation.startsAt);
    final time = formatRoomTimeRange(
      context,
      reservation.startsAt,
      reservation.endsAt,
    );
    final now = DateTime.now();
    final isOver = !reservation.endsAt.isAfter(now);
    final inProgress = !isOver && !reservation.startsAt.isAfter(now);
    final minutesLeft = reservation.endsAt.difference(now).inMinutes;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Details', style: AppTextStyles.heading),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: NetworkCover(
                url: null,
                label: 'Room',
                width: 112,
                height: 152,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(reservation.room.name, style: AppTextStyles.title),
            Text(date, style: AppTextStyles.body),
            Text(time, style: AppTextStyles.body),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isOver ? 'Completed' : 'Reserved to you',
              style: AppTextStyles.heading.copyWith(color: colors.tertiary),
            ),
            if (inProgress)
              Text(
                minutesLeft == 0
                    ? 'Less than a minute remaining'
                    : '$minutesLeft min remaining',
                style: AppTextStyles.body,
              ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Cancel Reservation',
              onPressed: () async {
                final cancelled = await confirmRoomCancellation(
                  context,
                  bookings,
                  reservation,
                );
                if (context.mounted && cancelled) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
