import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/app_text_field.dart';
import 'auth_validators.dart';

/// Sign-up screen. UI only in Step 2.2: the account is not really created.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _studentIdError;
  String? _passwordError;
  String? _confirmError;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _signUp() {
    setState(() {
      _nameError =
          AuthValidators.requiredField(_nameController.text, 'Full name');
      _emailError = AuthValidators.universityEmail(_emailController.text);
      _studentIdError =
          AuthValidators.requiredField(_studentIdController.text, 'Student ID');
      _passwordError = AuthValidators.password(_passwordController.text);
      _confirmError = AuthValidators.confirmPassword(
        _confirmController.text,
        _passwordController.text,
      );
    });

    final hasError = [
      _nameError,
      _emailError,
      _studentIdError,
      _passwordError,
      _confirmError,
    ].any((error) => error != null);
    if (hasError) return;

    _showSuccessDialog();
  }

  Future<void> _showSuccessDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Account created', style: AppTextStyles.heading),
        content: Text(
          'Welcome to LibraryHub, ${_nameController.text.trim()}! '
          'You can now log in.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Go to login'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop(); // back to the login screen
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: AppLogo(size: 48),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Create account', style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Join LibraryHub to borrow books and book study rooms',
              style: AppTextStyles.body.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: 'Full name',
              hint: 'Hasan Aydın',
              controller: _nameController,
              errorText: _nameError,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'University email',
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
              label: 'Password',
              hint: 'At least 8 characters',
              controller: _passwordController,
              obscureText: true,
              errorText: _passwordError,
              onChanged: (_) => setState(() {}), // refresh strength bar
            ),
            const SizedBox(height: AppSpacing.sm),
            _PasswordStrength(password: _passwordController.text),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Confirm password',
              hint: 'Repeat your password',
              controller: _confirmController,
              obscureText: true,
              errorText: _confirmError,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Checkbox(
                  value: _acceptedTerms,
                  activeColor: colors.primary,
                  checkColor: colors.onPrimary,
                  onChanged: (value) =>
                      setState(() => _acceptedTerms = value ?? false),
                ),
                Expanded(
                  child: Text(
                    'I agree to the Terms of Service and Privacy Policy',
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Disabled until the terms checkbox is ticked.
            AppButton(
              label: 'Sign up',
              onPressed: _acceptedTerms ? _signUp : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style:
                      AppTextStyles.body.copyWith(color: colors.onSurfaceVariant),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Log in',
                    style: AppTextStyles.body.copyWith(
                      color: colors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 4-bar password strength indicator shown under the password field.
class _PasswordStrength extends StatelessWidget {
  const _PasswordStrength({required this.password});

  final String password;

  int get _score {
    var score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final score = _score;
    const labels = ['Too short', 'Weak', 'Medium', 'Good', 'Strong'];
    final color = score <= 1
        ? colors.error
        : score == 2
            ? const Color(0xFFE5A100) // warning (due soon) color from the kit
            : colors.tertiary;

    return Row(
      children: [
        for (var i = 0; i < 4; i++) ...[
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: i < score ? color : colors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 64,
          child: Text(
            password.isEmpty ? '' : labels[score],
            style: AppTextStyles.caption.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
