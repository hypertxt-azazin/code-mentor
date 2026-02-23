import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:code_mentor/app/providers.dart';
import 'package:code_mentor/core/constants/strings.dart';
import 'package:code_mentor/features/catalog/controllers/catalog_controller.dart';
import 'package:code_mentor/features/catalog/domain/models/track.dart';
import 'package:code_mentor/features/progress/controllers/progress_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider);
    final tracksAsync = ref.watch(tracksProvider);
    final userId = profile?.id ?? '';
    final theme = Theme.of(context);
    final displayName =
        profile?.displayName ?? profile?.username ?? 'Learner';

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(tracksProvider);
          if (userId.isNotEmpty) {
            ref.invalidate(streakProvider(userId));
            ref.invalidate(lessonProgressProvider(userId));
            ref.invalidate(userBadgesProvider(userId));
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Welcome
            Text('Hello, $displayName 👋',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(AppStrings.tagline,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.secondary)),
            const SizedBox(height: 20),

            // Streak card
            if (userId.isNotEmpty)
              ref.watch(streakProvider(userId)).when(
                    loading: () => const SizedBox(height: 80),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (streak) => _StreakCard(
                      current: streak?.currentStreak ?? 0,
                      longest: streak?.longestStreak ?? 0,
                    ),
                  )
            else
              const _StreakCard(current: 0, longest: 0),
            const SizedBox(height: 20),

            // Quick stats
            Row(
              children: [
                Expanded(child: _LessonsStatWidget(userId: userId)),
                const SizedBox(width: 12),
                Expanded(child: _BadgesStatWidget(userId: userId)),
              ],
            ),
            const SizedBox(height: 24),

            // Popular tracks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Popular Tracks',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => context.go('/catalog'),
                  child: const Text(AppStrings.viewAll),
                ),
              ],
            ),
            const SizedBox(height: 8),
            tracksAsync.when(
              loading: () => const SizedBox(
                  height: 160, child: Center(child: CircularProgressIndicator())),
              error: (_, __) => const SizedBox.shrink(),
              data: (tracks) => SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: tracks.take(6).length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) =>
                      _HorizontalTrackCard(track: tracks[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonsStatWidget extends ConsumerWidget {
  final String userId;
  const _LessonsStatWidget({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (userId.isEmpty) {
      return const _StatCard(
          label: AppStrings.lessonsCompleted,
          value: '0',
          icon: Icons.menu_book,
          color: Colors.blue);
    }
    return ref.watch(lessonProgressProvider(userId)).when(
          loading: () => const SizedBox(height: 60),
          error: (_, __) => const SizedBox.shrink(),
          data: (progress) => _StatCard(
            label: AppStrings.lessonsCompleted,
            value: '${progress.length}',
            icon: Icons.menu_book,
            color: Colors.blue,
          ),
        );
  }
}

class _BadgesStatWidget extends ConsumerWidget {
  final String userId;
  const _BadgesStatWidget({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (userId.isEmpty) {
      return const _StatCard(
          label: AppStrings.badges,
          value: '0',
          icon: Icons.emoji_events,
          color: Colors.amber);
    }
    return ref.watch(userBadgesProvider(userId)).when(
          loading: () => const SizedBox(height: 60),
          error: (_, __) => const SizedBox.shrink(),
          data: (badges) => _StatCard(
            label: AppStrings.badges,
            value: '${badges.length}',
            icon: Icons.emoji_events,
            color: Colors.amber,
          ),
        );
  }
}

class _StreakCard extends StatelessWidget {
  final int current;
  final int longest;
  const _StreakCard({required this.current, required this.longest});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepOrange.shade400,
            Colors.orange.shade300,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department,
              color: Colors.white, size: 40),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$current ${AppStrings.days}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const Text(AppStrings.currentStreak,
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$longest',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const Text(AppStrings.longestStreak,
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold, color: color)),
              Text(label,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.secondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _HorizontalTrackCard extends StatelessWidget {
  final Track track;
  const _HorizontalTrackCard({required this.track});

  Color _difficultyColor(String d) {
    switch (d.toLowerCase()) {
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => context.push('/track/${track.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _difficultyColor(track.difficulty).withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                track.difficulty[0].toUpperCase() +
                    track.difficulty.substring(1),
                style: TextStyle(
                    fontSize: 11,
                    color: _difficultyColor(track.difficulty),
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            Text(track.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(
              track.tags.take(2).join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
