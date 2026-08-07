import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'api_service.dart';
import 'auth_provider.dart';
import 'login_screen.dart';
import 'models.dart';

final profileProvider = FutureProvider<User>((ref) {
  final username = ref.watch(authControllerProvider).username;
  if (username == null) {
    throw const ApiException('You are not logged in');
  }
  return ref.read(apiServiceProvider).fetchUserByUsername(username);
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).logout();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedAlert01,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 12),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        data: (user) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ProfileHeader(user: user),
            const SizedBox(height: 16),
            _InfoCard(user: user),
            const SizedBox(height: 24),
            FilledButton.tonalIcon(
              onPressed: () => _logout(context, ref),
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedLogout02,
                size: 20,
              ),
              label: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final User user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: colorScheme.primaryContainer,
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedUserCircle,
            size: 48,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          user.fullName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          '@${user.username}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final User user;

  const _InfoCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final address = user.address;

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const HugeIcon(
              icon: HugeIcons.strokeRoundedMail01,
              size: 22,
            ),
            title: Text(user.email),
            subtitle: const Text('Email'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const HugeIcon(
              icon: HugeIcons.strokeRoundedCall02,
              size: 22,
            ),
            title: Text(user.phone),
            subtitle: const Text('Phone'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const HugeIcon(
              icon: HugeIcons.strokeRoundedLocation01,
              size: 22,
            ),
            title: Text(
              '${address.street} ${address.number}, '
              '${address.city}, ${address.zipcode}',
            ),
            subtitle: const Text('Address'),
          ),
        ],
      ),
    );
  }
}
