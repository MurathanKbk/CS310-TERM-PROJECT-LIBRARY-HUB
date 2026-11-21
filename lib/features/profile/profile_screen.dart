import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock_user.dart';
import '../../models/app_user.dart';
import '../auth/login_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'profile_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser _user = mockUser;
  bool _dueReminders = true;
  bool _darkMode = false;

  Future<void> _editProfile() async {
    final updated = await Navigator.of(context).push<AppUser>(
      MaterialPageRoute(builder: (_) => EditProfileScreen(user: _user)),
    );
    if (updated != null) setState(() => _user = updated);
  }

  void _openChangePassword() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ChangePasswordScreen()),
    );
  }

  // Screens owned by other team members are linked here once they are merged.
  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature is coming soon.')));
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Log out?', style: AppTextStyles.heading),
        content: Text(
          'You will need to log in again to use LibraryHub.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Log out',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.heading),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            _ProfileHeader(user: _user, onEdit: _editProfile),
            const SectionLabel('Account'),
            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.menu_book_outlined,
                  label: 'My Borrowings',
                  onTap: () => _comingSoon('My Borrowings'),
                ),
                SettingsTile(
                  icon: Icons.meeting_room_outlined,
                  label: 'My Room Reservations',
                  onTap: () => _comingSoon('My Room Reservations'),
                ),
                SettingsTile(
                  icon: Icons.lock_outline,
                  label: 'Change Password',
                  onTap: _openChangePassword,
                ),
              ],
            ),
            const SectionLabel('Preferences'),
            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.notifications_none,
                  label: 'Notifications',
                  onTap: () => _comingSoon('Notifications'),
                ),
                SettingsTile(
                  icon: Icons.alarm,
                  label: 'Due date reminders',
                  trailing: Switch(
                    value: _dueReminders,
                    activeTrackColor: colors.primary,
                    onChanged: (value) => setState(() => _dueReminders = value),
                  ),
                ),
                SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  label: 'Dark mode',
                  trailing: Switch(
                    value: _darkMode,
                    activeTrackColor: colors.primary,
                    onChanged: (value) => setState(() => _darkMode = value),
                  ),
                ),
                SettingsTile(
                  icon: Icons.translate,
                  label: 'Language',
                  trailingText: 'English',
                  onTap: () => _comingSoon('Language selection'),
                ),
              ],
            ),
            const SectionLabel('Support'),
            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.help_outline,
                  label: 'Help & FAQ',
                  onTap: () => _comingSoon('Help & FAQ'),
                ),
                const SettingsTile(
                  icon: Icons.info_outline,
                  label: 'About LibraryHub',
                  trailingText: 'v1.0',
                  trailing: SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _confirmLogout,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(AppSpacing.minTapHeight),
                  foregroundColor: colors.error,
                  side: BorderSide(color: colors.error, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
                  ),
                ),
                child: Text('Log out', style: AppTextStyles.button),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user, required this.onEdit});

  final AppUser user;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        side: BorderSide(color: colors.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            InitialsAvatar(initials: user.initials),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: AppTextStyles.heading,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user.email,
                    style: AppTextStyles.caption.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            OutlinedButton(
              onPressed: onEdit,
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.secondary,
                side: BorderSide(color: colors.secondary),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
                ),
              ),
              child: Text('Edit', style: AppTextStyles.caption),
            ),
          ],
        ),
      ),
    );
  }
}
