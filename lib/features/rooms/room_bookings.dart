import 'package:flutter/foundation.dart';

import '../../data/mock_rooms.dart';
import '../../models/reservation.dart';
import '../../models/room.dart';

final demoRoomBookings = RoomBookings.demo(DateTime.now());

class RoomBookings extends ChangeNotifier {
  RoomBookings({
    Iterable<Reservation> reservations = const [],
    Iterable<Reservation> occupiedSlots = const [],
  }) : _reservations = reservations.toList(),
       _occupiedSlots = occupiedSlots.toList() {
    for (final reservation in _reservations) {
      if (reservation.id >= _nextId) _nextId = reservation.id + 1;
    }
  }

  factory RoomBookings.demo(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return RoomBookings(
      reservations: [
        Reservation(
          id: 1,
          room: mockRooms[2],
          startsAt: DateTime(now.year, now.month, now.day, 14),
          endsAt: DateTime(now.year, now.month, now.day, 16),
        ),
      ],
      occupiedSlots: [
        for (final room in [mockRooms[1], mockRooms[3]])
          Reservation(
            id: -room.id,
            room: room,
            startsAt: today,
            endsAt: tomorrow,
          ),
      ],
    );
  }

  static const maxDuration = Duration(hours: 2);

  final List<Reservation> _reservations;
  final List<Reservation> _occupiedSlots;
  int _nextId = 1;

  List<Reservation> get reservations => List.unmodifiable(_reservations);

  List<Reservation> upcomingReservations(DateTime now) =>
      _reservations
          .where((reservation) => reservation.endsAt.isAfter(now))
          .toList()
        ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

  Iterable<Reservation> _schedule(Room room) sync* {
    for (final reservation in [..._occupiedSlots, ..._reservations]) {
      if (reservation.room.id == room.id) yield reservation;
    }
  }

  bool isScheduledToday(Room room, DateTime now) {
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return overlaps(room, now, tomorrow);
  }

  bool isBookedAllDay(Room room, DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day + 1);
    return _schedule(room).any(
      (reservation) =>
          !reservation.startsAt.isAfter(start) &&
          !reservation.endsAt.isBefore(end),
    );
  }

  bool overlaps(Room room, DateTime start, DateTime end) {
    return _schedule(room).any(
      (reservation) =>
          reservation.startsAt.isBefore(end) &&
          reservation.endsAt.isAfter(start),
    );
  }

  Reservation? reserve(Room room, DateTime start, DateTime end) {
    if (start.isBefore(DateTime.now()) ||
        !end.isAfter(start) ||
        end.difference(start) > maxDuration ||
        overlaps(room, start, end)) {
      return null;
    }
    final reservation = Reservation(
      id: _nextId++,
      room: room,
      startsAt: start,
      endsAt: end,
    );
    _reservations.add(reservation);
    notifyListeners();
    return reservation;
  }

  void cancel(Reservation reservation) {
    if (_reservations.remove(reservation)) notifyListeners();
  }
}
