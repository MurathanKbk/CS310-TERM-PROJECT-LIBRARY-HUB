import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/reservation.dart';
import '../../models/room.dart';
import 'room_booking_format.dart';
import 'room_bookings.dart';

class RoomBookingScreen extends StatefulWidget {
  const RoomBookingScreen({
    super.key,
    required this.room,
    required this.bookings,
  });

  final Room room;
  final RoomBookings bookings;

  @override
  State<RoomBookingScreen> createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> {
  static final _interval = RegExp(
    r'^([01]?\d|2[0-3]):([0-5]\d)\s*[-–]\s*([01]?\d|2[0-3]):([0-5]\d)$',
  );

  final _dateText = TextEditingController();
  final _timeText = TextEditingController();
  DateTime? _date;
  String? _dateError;
  String? _timeError;

  @override
  void dispose() {
    _dateText.dispose();
    _timeText.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final current = _date;
    final selected = await showDatePicker(
      context: context,
      initialDate: current != null && !current.isBefore(today)
          ? current
          : today,
      firstDate: today,
      lastDate: DateTime(today.year + 1, today.month, today.day),
    );
    if (!mounted || selected == null) return;
    setState(() {
      _date = selected;
      _dateText.text = MaterialLocalizations.of(context)
          .formatMediumDate(selected);
      _dateError = null;
      _timeError = null;
    });
  }

  Future<void> _continueBooking() async {
    final date = _date;
    final now = DateTime.now();
    final match = _interval.firstMatch(_timeText.text.trim());
    String? dateError;
    String? timeError;

    if (date == null) {
      dateError = 'Select a reservation date.';
    } else if (date.isBefore(DateUtils.dateOnly(now))) {
      dateError = 'Choose today or a future date.';
    } else if (widget.bookings.isBookedAllDay(widget.room, date)) {
      dateError = 'This room is booked all day. Choose another date.';
    }

    if (match == null) {
      timeError = 'Enter a time range like 17:00 - 19:00.';
    }
    if (dateError != null ||
        timeError != null ||
        date == null ||
        match == null) {
      setState(() {
        _dateError = dateError;
        _timeError = timeError;
      });
      return;
    }

    final start = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(match[1]!),
      int.parse(match[2]!),
    );
    final end = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(match[3]!),
      int.parse(match[4]!),
    );
    if (!end.isAfter(start)) {
      timeError = 'The end time must be after the start time.';
    } else if (start.isBefore(now)) {
      timeError = 'Choose a start time in the future.';
    } else if (end.difference(start) > RoomBookings.maxDuration) {
      timeError = 'The maximum booking length is two hours.';
    } else if (widget.bookings.overlaps(widget.room, start, end)) {
      timeError = 'This time overlaps another booking. Choose another time.';
    }
    setState(() {
      _dateError = null;
      _timeError = timeError;
    });
    if (timeError != null) return;

    FocusScope.of(context).unfocus();
    final localizations = MaterialLocalizations.of(context);
    final timeRange = formatRoomTimeRange(context, start, end);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Reservation', style: AppTextStyles.heading),
        content: Text(
          '${widget.room.name}\n${localizations.formatMediumDate(date)}\n$timeRange',
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    final reservation = widget.bookings.reserve(widget.room, start, end);
    if (reservation == null) {
      setState(
        () => _timeError =
            'This time is no longer available. Choose another time.',
      );
      return;
    }
    Navigator.pop<Reservation>(context, reservation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve Room', style: AppTextStyles.heading),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Text(widget.room.name, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Reservation Date',
              hint: 'Select a date',
              controller: _dateText,
              readOnly: true,
              onTap: _pickDate,
              errorText: _dateError,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Time Interval',
              hint: '17:00 - 19:00',
              controller: _timeText,
              errorText: _timeError,
              onChanged: (_) => setState(() => _timeError = null),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: 'Continue', onPressed: _continueBooking),
          ],
        ),
      ),
    );
  }
}
