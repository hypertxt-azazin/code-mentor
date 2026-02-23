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

            // ── Today's Plan ──────────────────────────────────────────
            _SectionHeader(title: AppStrings.todayPlan),
            const SizedBox(height: 8),
            _TodayPlanCard(userId: userId, tracksAsync: tracksAsync),
            const SizedBox(height: 20),

            // ── Continue ──────────────────────────────────────────────
            _SectionHeader(title: AppStrings.continueSection),
            const SizedBox(height: 8),
            _ContinueCard(userId: userId, tracksAsync: tracksAsync),
            const SizedBox(height: 20),

            // ── Streak ────────────────────────────────────────────────
            _SectionHeader(title: AppStrings.streak),
            const SizedBox(height: 8),
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

            // ── Recommended Roadmaps ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.recommendedRoadmaps,
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

/// Simple section header widget.
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold));
  }
}

/// Today's Plan: shows the next incomplete card the user should tackle.
class _TodayPlanCard extends ConsumerWidget {
  final String userId;
  final AsyncValue<List<Track>> tracksAsync;
  const _TodayPlanCard({required this.userId, required this.tracksAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (userId.isEmpty) {
      return _PlanPlaceholder(
        message: 'Sign in to see your personalised plan.',
        icon: Icons.calendar_today,
      );
    }

    final progressAsync = ref.watch(lessonProgressProvider(userId));

    return progressAsync.when(
      loading: () => const SizedBox(height: 72),
      error: (_, __) => const SizedBox.shrink(),
      data: (progress) {
        final completedIds =
            progress.where((p) => p.isCompleted).map((p) => p.lessonId).toSet();
        final inProgressIds = progress
            .where((p) => !p.isCompleted)
            .map((p) => p.lessonId)
            .toList();

        // Show count of in-progress cards, or encourage start
        final inProgressCount = inProgressIds.length;
        final completedCount = completedIds.length;
        final total = progress.length;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.35),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: 32),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inProgressCount > 0
                          ? '$inProgressCount card${inProgressCount == 1 ? '' : 's'} in progress'
                          : completedCount > 0
                              ? 'Great work! Keep the momentum going.'
                              : 'Start your first roadmap today!',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (total > 0)
                      Text(
                        '$completedCount / $total cards completed',
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        );
      },
    );
  }
}

/// Continue: prominent resume area for the last in-progress roadmap.
class _ContinueCard extends ConsumerWidget {
  final String userId;
  final AsyncValue<List<Track>> tracksAsync;
  const _ContinueCard({required this.userId, required this.tracksAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return tracksAsync.when(
      loading: () => const SizedBox(height: 72),
      error: (_, __) => const SizedBox.shrink(),
      data: (tracks) {
        if (tracks.isEmpty) {
          return _PlanPlaceholder(
            message: 'No roadmaps available yet.',
            icon: Icons.map_outlined,
          );
        }
        // Use the first track as the "continue" item
        final track = tracks.first;
        return InkWell(
          onTap: () => context.push('/track/${track.id}'),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.7),
                  theme.colorScheme.primary,
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.play_circle_filled,
                    color: Colors.white, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppStrings.continueTrack,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlanPlaceholder extends StatelessWidget {
  final String message;
  final IconData icon;
  const _PlanPlaceholder({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
              child: Text(message, style: theme.textTheme.bodyMedium)),
        ],
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
