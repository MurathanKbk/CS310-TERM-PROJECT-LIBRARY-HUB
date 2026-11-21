import 'package:flutter/material.dart';

String formatRoomTimeRange(BuildContext context, DateTime start, DateTime end) {
  final localizations = MaterialLocalizations.of(context);
  String time(DateTime value) => localizations.formatTimeOfDay(
    TimeOfDay.fromDateTime(value),
    alwaysUse24HourFormat: true,
  );
  return '${time(start)} - ${time(end)}';
}
