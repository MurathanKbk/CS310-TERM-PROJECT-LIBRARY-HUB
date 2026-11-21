import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/app_user.dart';
import '../auth/auth_validators.dart';
import 'profile_widgets.dart';

/// Edit profile form. Returns the updated [AppUser] with Navigator.pop.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.user});

  final AppUser user;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final _nameController = TextEditingController(text: widget.user.fullName);
  late final _emailController = TextEditingController(text: widget.user.email);
  late final _studentIdController =
      TextEditingController(text: widget.user.studentId);
  late final _phoneController = TextEditingController(text: widget.user.phone);

  String? _nameError;
  String? _emailError;
  String? _studentIdError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _nameError =
          AuthValidators.requiredField(_nameController.text, 'Full name');
      _emailError = AuthValidators.email(_emailController.text);
      _studentIdError =
          AuthValidators.requiredField(_studentIdController.text, 'Student ID');
    });
    if (_nameError != null || _emailError != null || _studentIdError != null) {
      return;
    }

    final updated = widget.user.copyWith(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      studentId: _studentIdController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Profile updated', style: AppTextStyles.heading),
        content: Text(
          'Your profile information has been saved.',
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
    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: AppTextStyles.heading),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Center(
              child: InitialsAvatar(initials: widget.user.initials, size: 96),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Full name',
              hint: 'Your full name',
              controller: _nameController,
              errorText: _nameError,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Email',
              hint: 'name@sabanciuniv.edu',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Student ID',
              hint: '00012345',
              controller: _studentIdController,
              keyboardType: TextInputType.number,
              errorText: _studentIdError,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Phone number',
              hint: '+90 5xx xxx xx xx',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: 'Save changes', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
