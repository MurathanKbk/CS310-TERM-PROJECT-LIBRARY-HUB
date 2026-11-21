import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/network_cover.dart';
import '../../models/reservation.dart';
import '../../models/room.dart';
import 'room_booking_screen.dart';
import 'room_bookings.dart';
import 'room_reservations_screen.dart';

class RoomDetailsScreen extends StatelessWidget {
  const RoomDetailsScreen({super.key, required this.room, this.bookings});

  final Room room;
  final RoomBookings? bookings;

  Future<void> _reserve(BuildContext context, RoomBookings roomBookings) async {
    final reservation = await Navigator.of(context).push<Reservation>(
      MaterialPageRoute(
        builder: (_) => RoomBookingScreen(room: room, bookings: roomBookings),
      ),
    );
    if (!context.mounted || reservation == null) return;
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => RoomReservationDetailsScreen(
          reservation: reservation,
          bookings: roomBookings,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roomBookings = bookings ?? demoRoomBookings;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Details', style: AppTextStyles.heading),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
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
            Text(room.name, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.sm),
            ListenableBuilder(
              listenable: roomBookings,
              builder: (context, _) {
                final scheduled = roomBookings.isScheduledToday(
                  room,
                  DateTime.now(),
                );
                return Text(
                  scheduled ? 'Scheduled today' : 'Available',
                  style: AppTextStyles.heading.copyWith(
                    color: scheduled ? colors.error : colors.tertiary,
                  ),
                );
              },
            ),
            const Text(
              'You can reserve this room for up to two hours.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Reserve',
              onPressed: () => _reserve(context, roomBookings),
            ),
          ],
        ),
      ),
    );
  }
}
