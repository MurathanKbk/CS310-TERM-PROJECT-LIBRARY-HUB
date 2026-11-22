import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/app_text_field.dart';
import '../home/home_screen.dart';
import 'auth_validators.dart';
import 'sign_up_screen.dart';
import '../shell/main_shell.dart';
/// Login screen. UI only in Step 2.2: no real authentication yet.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    setState(() {
      _emailError = AuthValidators.email(_emailController.text);
      _passwordError =
          AuthValidators.requiredField(_passwordController.text, 'Password');
    });
    if (_emailError != null || _passwordError != null) return;

    // Valid input: go to the home screen and remove login from the back stack.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const MainShell()),
    );
  }

  void _showForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset will be available in the next step.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            const SizedBox(height: AppSpacing.xl),
            const Align(
              alignment: Alignment.centerLeft,
              child: AppLogo(size: 48),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Welcome back', style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Log in to continue to LibraryHub',
              style: AppTextStyles.body.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: 'Email',
              hint: 'name@sabanciuniv.edu',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
              onChanged: (_) {
                if (_emailError != null) setState(() => _emailError = null);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Password',
              hint: '••••••••',
              controller: _passwordController,
              obscureText: true,
              errorText: _passwordError,
              onChanged: (_) {
                if (_passwordError != null) {
                  setState(() => _passwordError = null);
                }
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _showForgotPassword,
                child: Text(
                  'Forgot password?',
                  style: AppTextStyles.body.copyWith(color: colors.secondary),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(label: 'Log in', onPressed: _login),
            const SizedBox(height: AppSpacing.lg),
            _BottomLink(
              text: "Don't have an account?",
              linkText: 'Sign up',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SignUpScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Question? Link" row used at the bottom of the auth screens.
class _BottomLink extends StatelessWidget {
  const _BottomLink({
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  final String text;
  final String linkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          text,
          style: AppTextStyles.body.copyWith(color: colors.onSurfaceVariant),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            linkText,
            style: AppTextStyles.body.copyWith(
              color: colors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
