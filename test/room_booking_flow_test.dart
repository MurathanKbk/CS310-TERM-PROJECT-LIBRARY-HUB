import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_hub/core/theme/app_theme.dart';
import 'package:library_hub/data/mock_rooms.dart';
import 'package:library_hub/features/home/home_screen.dart';
import 'package:library_hub/features/rooms/room_bookings.dart';
import 'package:library_hub/models/reservation.dart';

Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> selectDate(WidgetTester tester, DateTime date) async {
  await tapAndSettle(tester, find.byType(TextField).first);
  final dialog = find.byType(DatePickerDialog);
  await tapAndSettle(
    tester,
    find.descendant(of: dialog, matching: find.byIcon(Icons.edit_outlined)),
  );
  await tester.enterText(
    find.descendant(of: dialog, matching: find.byType(TextField)),
    '${date.month}/${date.day}/${date.year}',
  );
  await tapAndSettle(tester, find.text('OK'));
}

void main() {
  for (final (width, theme) in [
    (320.0, ThemeMode.light),
    (430.0, ThemeMode.dark),
  ]) {
    testWidgets('Book and cancel a room at $width in ${theme.name} mode', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final room = mockRooms.first;
      final bookings = RoomBookings(
        occupiedSlots: [
          Reservation(
            id: -1,
            room: room,
            startsAt: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 14),
            endsAt: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 16),
          ),
        ],
      );
      addTearDown(bookings.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: theme,
          home: HomeScreen(bookings: bookings),
        ),
      );

      await tapAndSettle(tester, find.text('Browse Rooms'));
      await tester.enterText(find.byType(TextField), ' STUDY ROOM 1 ');
      await tester.pumpAndSettle();
      await tapAndSettle(tester, find.text(room.name));
      await tapAndSettle(tester, find.text('Reserve'));
      await tapAndSettle(tester, find.text('Continue'));
      expect(find.text('Select a reservation date.'), findsOneWidget);
      expect(find.textContaining('Enter a time range'), findsOneWidget);

      await selectDate(tester, tomorrow);
      for (final (range, error) in [
        ('16:00 - 14:00', 'The end time must be after the start time.'),
        ('17:00 - 20:00', 'The maximum booking length is two hours.'),
        ('15:00 - 16:00', 'This time overlaps another booking.'),
      ]) {
        await tester.enterText(find.byType(TextField).last, range);
        await tapAndSettle(tester, find.text('Continue'));
        expect(find.textContaining(error), findsOneWidget);
      }

      await tester.enterText(find.byType(TextField).last, '16:00 - 18:00');
      await tapAndSettle(tester, find.text('Continue'));
      expect(find.text('Confirm Reservation'), findsOneWidget);
      await tapAndSettle(tester, find.text('Cancel'));
      expect(bookings.reservations, isEmpty);
      expect(find.text('16:00 - 18:00'), findsOneWidget);
      await tapAndSettle(tester, find.text('Continue'));
      await tapAndSettle(tester, find.text('Confirm'));
      expect(find.text('Reservation Details'), findsOneWidget);
      expect(bookings.reservations.single.room.id, room.id);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tapAndSettle(tester, find.text('My Room Reservations'));
      await tapAndSettle(
        tester,
        find.byTooltip('Cancel ${room.name} reservation'),
      );
      await tapAndSettle(tester, find.text('Keep Booking'));
      expect(bookings.reservations, hasLength(1));
      await tapAndSettle(
        tester,
        find.byTooltip('Cancel ${room.name} reservation'),
      );
      await tapAndSettle(tester, find.text('Confirm'));
      expect(find.text('No room reservations yet.'), findsOneWidget);
      expect(bookings.reservations, isEmpty);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Home cancellation updates availability and notifications', (
    tester,
  ) async {
    final now = DateTime.now();
    final room = mockRooms[2];
    final reservations = [
      Reservation(
        id: 1,
        room: room,
        startsAt: DateUtils.dateOnly(now),
        endsAt: DateTime(now.year, now.month, now.day + 1),
      ),
    ];
    final bookings = RoomBookings(reservations: reservations);
    addTearDown(bookings.dispose);
    await tester.pumpWidget(MaterialApp(home: HomeScreen(bookings: bookings)));

    await tapAndSettle(tester, find.byTooltip('Notifications'));
    expect(find.text('Room booking'), findsOneWidget);
    expect(find.text('Book due date'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.text('Browse Rooms'));
    await tapAndSettle(tester, find.widgetWithText(ChoiceChip, 'Scheduled'));
    expect(find.text(room.name), findsOneWidget);
    expect(find.text(mockRooms.first.name), findsNothing);
    await tapAndSettle(tester, find.text(room.name));
    await tapAndSettle(tester, find.text('Reserve'));
    await selectDate(tester, now);
    await tester.enterText(find.byType(TextField).last, '14:00 - 16:00');
    await tapAndSettle(tester, find.text('Continue'));
    expect(find.textContaining('This room is booked all day'), findsOneWidget);

    for (var route = 0; route < 3; route++) {
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
    await tapAndSettle(
      tester,
      find.byTooltip('Cancel ${room.name} reservation'),
    );
    await tapAndSettle(tester, find.text('Confirm'));
    expect(find.text('No room bookings today.'), findsOneWidget);
    expect(bookings.isScheduledToday(room, now), isFalse);
    await tapAndSettle(tester, find.byTooltip('Notifications'));
    expect(find.text('Room booking'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
