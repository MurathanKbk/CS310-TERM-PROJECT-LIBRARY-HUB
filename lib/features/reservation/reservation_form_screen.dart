import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/book_card.dart';
import '../../models/book.dart';

/// Reservation form: pickup date + borrow duration.
/// Validates inline and shows a confirmation dialog on success.
class ReservationFormScreen extends StatefulWidget {
  const ReservationFormScreen({super.key, required this.book});

  final Book book;

  @override
  State<ReservationFormScreen> createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends State<ReservationFormScreen> {
  final _dateController = TextEditingController();
  final _durationController = TextEditingController();
  String? _dateError;
  String? _durationError;

  @override
  void dispose() {
    _dateController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (picked == null) return;
    setState(() {
      _dateController.text =
      '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      _dateError = null;
    });
  }

  String? _validateDuration(String value) {
    final text = value.trim();
    if (text.isEmpty) return 'Please enter a borrow duration';
    final days = int.tryParse(text);
    if (days == null) return 'Duration must be a number';
    if (days < 1 || days > 30) return 'Duration must be between 1 and 30 days';
    return null;
  }

  void _submit() {
    setState(() {
      _dateError =
      _dateController.text.isEmpty ? 'Please select a pickup date' : null;
      _durationError = _validateDuration(_durationController.text);
    });
    if (_dateError != null || _durationError != null) return;
    _showConfirmation();
  }

  Future<void> _showConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Confirm Reservation', style: AppTextStyles.heading),
        content: Text(
          'Reserve "${widget.book.title}" for pickup on '
              '${_dateController.text} '
              'for ${_durationController.text.trim()} days?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${widget.book.title}" reserved.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve Book', style: AppTextStyles.heading),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          BookCard(book: widget.book),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Pickup date',
            hint: 'Select a date',
            controller: _dateController,
            errorText: _dateError,
            readOnly: true,
            onTap: _pickDate,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Borrow duration (days)',
            hint: 'e.g. 14',
            controller: _durationController,
            errorText: _durationError,
            keyboardType: TextInputType.number,
            onChanged: (_) {
              if (_durationError != null) setState(() => _durationError = null);
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Continue', onPressed: _submit),
        ],
      ),
    );
  }
}