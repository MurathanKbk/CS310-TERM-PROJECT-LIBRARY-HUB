import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../auth/auth_validators.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _currentError;
  String? _newError;
  String? _confirmError;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    setState(() {
      _currentError = AuthValidators.requiredField(
        _currentController.text,
        'Current password',
      );
      _newError = AuthValidators.password(_newController.text);
      if (_newError == null && _newController.text == _currentController.text) {
        _newError = 'New password must be different from the current one';
      }
      _confirmError = AuthValidators.confirmPassword(
        _confirmController.text,
        _newController.text,
      );
    });
    if (_currentError != null || _newError != null || _confirmError != null) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Password updated', style: AppTextStyles.heading),
        content: Text(
          'Your password has been changed successfully.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password', style: AppTextStyles.heading),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Text(
              'Your new password must be at least 8 characters.',
              style: AppTextStyles.body.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Current password',
              hint: '••••••••',
              controller: _currentController,
              obscureText: true,
              errorText: _currentError,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'New password',
              hint: 'At least 8 characters',
              controller: _newController,
              obscureText: true,
              errorText: _newError,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Confirm new password',
              hint: 'Repeat the new password',
              controller: _confirmController,
              obscureText: true,
              errorText: _confirmError,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: 'Update password', onPressed: _update),
          ],
        ),
      ),
    );
  }
}
