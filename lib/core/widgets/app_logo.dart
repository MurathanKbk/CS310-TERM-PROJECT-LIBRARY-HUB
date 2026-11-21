import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// LibraryHub logo loaded from a local asset image.
/// If the asset is missing, it falls back to a book icon so the UI never breaks.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96});

  final double size;

  static const assetPath = 'assets/images/libraryhub_logo.png';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 4),
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => Container(
          width: size,
          height: size,
          color: colors.primary,
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FittedBox(
            child: Icon(Icons.menu_book_rounded, color: colors.onPrimary),
          ),
        ),
      ),
    );
  }
}
