import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:code_mentor/app/providers.dart';
import 'package:code_mentor/core/constants/strings.dart';
import 'package:code_mentor/features/auth/controllers/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final theme = Theme.of(context);

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final displayName =
        profile.displayName ?? profile.username ?? 'Learner';
    final initials = displayName.isNotEmpty
        ? displayName.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : '?';

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar + name section
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(displayName,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                if (profile.username != null)
                  Text('@${profile.username}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.secondary)),
                const SizedBox(height: 8),
                if (isPremium)
                  Chip(
                    avatar: const Icon(Icons.workspace_premium,
                        color: Colors.amber, size: 16),
                    label: const Text(AppStrings.premium,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.amber.withOpacity(0.15),
                  )
                else
                  OutlinedButton.icon(
                    icon: const Icon(Icons.workspace_premium, size: 16),
                    label: const Text(AppStrings.upgrade),
                    onPressed: () => context.push('/premium'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),

          // Interests section
          ListTile(
            leading: const Icon(Icons.interests),
            title: const Text('Edit Interests'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/onboarding'),
          ),
          const Divider(),

          // Settings
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text(AppStrings.darkMode),
            trailing: Switch(
              value: false,
              onChanged: (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Theme switching coming soon')),
                );
              },
            ),
          ),
          const Divider(),

          // Premium CTA
          if (!isPremium) ...[
            ListTile(
              leading: const Icon(Icons.workspace_premium, color: Colors.amber),
              title: const Text(AppStrings.upgrade),
              subtitle: const Text('Unlock all stages & unlimited drills'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/premium'),
            ),
            const Divider(),
          ],

          // Sign out
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(AppStrings.signOut,
                style: TextStyle(color: Colors.red)),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text(AppStrings.signOut),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(AppStrings.cancel)),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(AppStrings.signOut)),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                await ref.read(authControllerProvider.notifier).signOut();
              }
            },
          ),
        ],
      ),
    );
  }
}
