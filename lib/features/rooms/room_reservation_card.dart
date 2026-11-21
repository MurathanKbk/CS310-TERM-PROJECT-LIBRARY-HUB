import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/network_cover.dart';
import '../../models/reservation.dart';
import 'room_booking_format.dart';

class RoomReservationCard extends StatelessWidget {
  const RoomReservationCard({
    super.key,
    required this.reservation,
    required this.onTap,
    required this.onCancel,
  });

  final Reservation reservation;
  final VoidCallback onTap;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final date = MaterialLocalizations.of(context)
        .formatMediumDate(reservation.startsAt);
    final time = formatRoomTimeRange(
      context,
      reservation.startsAt,
      reservation.endsAt,
    );
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        side: BorderSide(color: colors.outline),
      ),
      child: ListTile(
        leading: const NetworkCover(url: null, label: 'Room', height: 40),
        title: Text(reservation.room.name, style: AppTextStyles.heading),
        subtitle: Text('$date\n$time', style: AppTextStyles.body),
        isThreeLine: true,
        onTap: onTap,
        trailing: IconButton(
          tooltip: 'Cancel ${reservation.room.name} reservation',
          onPressed: onCancel,
          icon: Icon(Icons.close, color: colors.error),
        ),
      ),
    );
  }
}
