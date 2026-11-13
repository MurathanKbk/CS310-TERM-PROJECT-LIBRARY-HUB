import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';


class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
    );
    const size = Size.fromHeight(AppSpacing.minTapHeight);

    return SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: size,
          shape: shape,
          foregroundColor: colors.onSurface,
          side: BorderSide(color: colors.secondary, width: 1.5),
        ),
        child: Text(label, style: AppTextStyles.button),
      )
          : ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: size,
          shape: shape,
          elevation: 0,
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.outline,
          disabledForegroundColor: colors.onSurface.withAlpha(128),
        ),
        child: Text(label, style: AppTextStyles.button),
      ),
    );
  }
}