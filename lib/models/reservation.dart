import 'room.dart';

class Reservation {
  const Reservation({
    required this.id,
    required this.room,
    required this.startsAt,
    required this.endsAt,
  });

  final int id;
  final Room room;
  final DateTime startsAt;
  final DateTime endsAt;
}
