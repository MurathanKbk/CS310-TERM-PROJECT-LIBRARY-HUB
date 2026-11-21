import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_hub/core/theme/app_theme.dart';
import 'package:library_hub/data/mock_rooms.dart';
import 'package:library_hub/features/home/home_screen.dart';
import 'package:library_hub/features/rooms/room_bookings.dart';
import 'package:library_hub/models/reservation.dart';

import 'room_booking_flow_test.dart' show tapAndSettle;

void main() {
  testWidgets('Home search opens the filtered book catalog', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final bookings = RoomBookings();
    addTearDown(bookings.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: HomeScreen(bookings: bookings),
      ),
    );
    final logo = tester.widget<Image>(
      find.byWidgetPredicate(
        (widget) => widget is Image && widget.image is AssetImage,
      ),
    );
    expect(
      (logo.image as AssetImage).assetName,
      'assets/images/libraryhub_logo.png',
    );
    expect(find.text('Book reminder'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '  ROBERT  ');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('Books'), findsOneWidget);
    expect(find.text('Clean Code'), findsOneWidget);
    expect(find.text('Design Patterns'), findsNothing);
    await tapAndSettle(tester, find.text('Clean Code'));
    expect(find.text('Book Details'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Home room reminder links to notifications and updates on cancel',
    (tester) async {
      final now = DateTime.now();
      final bookings = RoomBookings(
        reservations: [
          Reservation(
            id: 1,
            room: mockRooms.first,
            startsAt: now,
            endsAt: now.add(const Duration(hours: 1)),
          ),
        ],
      );
      addTearDown(bookings.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: HomeScreen(bookings: bookings),
        ),
      );
      expect(find.textContaining('+1 more'), findsOneWidget);
      await tapAndSettle(tester, find.text('Room reminder'));
      expect(find.text('Notifications'), findsOneWidget);
      await tapAndSettle(tester, find.text('Room booking'));
      await tapAndSettle(tester, find.text('Cancel Reservation'));
      await tapAndSettle(tester, find.text('Confirm'));
      expect(find.text('Room booking'), findsNothing);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Book reminder'), findsOneWidget);
      expect(find.text('Room reminder'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
