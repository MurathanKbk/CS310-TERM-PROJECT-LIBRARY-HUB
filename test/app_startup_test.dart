import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_hub/features/auth/splash_screen.dart';
import 'package:library_hub/features/home/home_screen.dart';
import 'package:library_hub/features/rooms/rooms_screen.dart';
import 'package:library_hub/main.dart';

void main() {
  testWidgets('Splash and login lead to room booking', (tester) async {
    await tester.pumpWidget(const LibraryHubApp());
    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));
    await tester.enterText(fields.first, 'demo@example.com');
    await tester.enterText(fields.last, 'demo-password');
    final loginButton = find.text('Log in');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    final browseRooms = find.text('Browse Rooms');
    await tester.ensureVisible(browseRooms);
    await tester.tap(browseRooms);
    await tester.pumpAndSettle();

    expect(find.byType(RoomsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
