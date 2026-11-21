import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/network_cover.dart';
import '../../data/mock_rooms.dart';
import '../../models/room.dart';
import 'room_bookings.dart';
import 'room_details_screen.dart';
import 'room_reservations_screen.dart';

enum _RoomFilter { all, available, scheduled }

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({
    super.key,
    this.onRoomSelected,
    this.bookings,
    this.showBackButton = false,
  });

  final ValueChanged<Room>? onRoomSelected;
  final RoomBookings? bookings;
  final bool showBackButton;

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  String _query = '';
  _RoomFilter _filter = _RoomFilter.all;

  @override
  Widget build(BuildContext context) {
    final bookings = widget.bookings ?? demoRoomBookings;
    final onRoomSelected = widget.onRoomSelected;

    return Scaffold(
      appBar: widget.showBackButton
          ? AppBar(title: const Text('Rooms', style: AppTextStyles.heading))
          : null,
      body: SafeArea(
        top: !widget.showBackButton,
        child: ListenableBuilder(
          listenable: bookings,
          builder: (context, _) {
            final colors = Theme.of(context).colorScheme;
            final now = DateTime.now();
            final scheduled = {
              for (final room in mockRooms)
                room.id: bookings.isScheduledToday(room, now),
            };
            final rooms = mockRooms.where((room) {
              final matchesFilter = switch (_filter) {
                _RoomFilter.all => true,
                _RoomFilter.available => !scheduled[room.id]!,
                _RoomFilter.scheduled => scheduled[room.id]!,
              };
              return matchesFilter && room.name.toLowerCase().contains(_query);
            }).toList();

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                if (!widget.showBackButton) ...[
                  const Text('Rooms', style: AppTextStyles.title),
                  const SizedBox(height: AppSpacing.md),
                ],
                AppTextField(
                  label: 'Search',
                  hint: 'Search by room name',
                  onChanged: (value) => setState(() {
                    _query = value.trim().toLowerCase();
                  }),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    for (final (filter, label) in const [
                      (_RoomFilter.all, 'All'),
                      (_RoomFilter.available, 'Available'),
                      (_RoomFilter.scheduled, 'Scheduled'),
                    ])
                      ChoiceChip(
                        label: Text(label),
                        labelStyle: AppTextStyles.caption,
                        selected: _filter == filter,
                        selectedColor: colors.primaryContainer,
                        showCheckmark: false,
                        onSelected: (_) => setState(() => _filter = filter),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (rooms.isEmpty)
                  const Center(
                    child: Text('No rooms found', style: AppTextStyles.body),
                  ),
                for (final room in rooms) ...[
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    color: colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.cardRadius,
                      ),
                      side: BorderSide(color: colors.outline),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      leading: const NetworkCover(
                        url: null,
                        label: 'Room',
                        height: 40,
                      ),
                      title: Text(room.name, style: AppTextStyles.heading),
                      subtitle: Text(
                        scheduled[room.id]! ? 'Scheduled today' : 'Available',
                        style: AppTextStyles.caption.copyWith(
                          color: scheduled[room.id]!
                              ? colors.error
                              : colors.tertiary,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        if (onRoomSelected != null) {
                          onRoomSelected(room);
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => RoomDetailsScreen(
                              room: room,
                              bookings: bookings,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'My Room Reservations',
                  outlined: true,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          MyRoomReservationsScreen(bookings: bookings),
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
