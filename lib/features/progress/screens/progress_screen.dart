import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_mentor/app/providers.dart';
import 'package:code_mentor/core/constants/strings.dart';
import 'package:code_mentor/core/widgets/error_widget.dart';
import 'package:code_mentor/core/widgets/loading_widget.dart';
import 'package:code_mentor/features/progress/controllers/progress_controller.dart';
import 'package:code_mentor/features/progress/domain/models/badge.dart';
import 'package:code_mentor/features/progress/domain/models/user_badge.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  IconData _badgeIcon(String iconName) {
    switch (iconName) {
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'check_circle':
        return Icons.check_circle;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'school':
        return Icons.school;
      case 'flag':
        return Icons.flag;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider);
    final userId = profile?.id ?? '';
    final theme = Theme.of(context);

    if (userId.isEmpty) {
      return const Scaffold(body: Center(child: Text('Not signed in')));
    }

    final streakAsync = ref.watch(streakProvider(userId));
    final badgesAsync = ref.watch(userBadgesProvider(userId));
    final allBadgesResult = ref.watch(allBadgesProvider);
    final progressAsync = ref.watch(lessonProgressProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.progress),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(streakProvider(userId));
          ref.invalidate(userBadgesProvider(userId));
          ref.invalidate(allBadgesProvider);
          ref.invalidate(lessonProgressProvider(userId));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Streak ──────────────────────────────────────────────
            Text(AppStrings.streak,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            streakAsync.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(message: e.toString()),
              data: (streak) => _StreakCard(
                current: streak?.currentStreak ?? 0,
                longest: streak?.longestStreak ?? 0,
              ),
            ),
            const SizedBox(height: 24),

            // ── Badges ──────────────────────────────────────────────
            Text(AppStrings.badges,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            badgesAsync.when(
              loading: () => const SizedBox(height: 80, child: LoadingWidget()),
              error: (e, _) => AppErrorWidget(message: e.toString()),
              data: (userBadges) => allBadgesResult.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (allBadges) {
                  final earnedKeys =
                      userBadges.map((ub) => ub.badgeKey).toSet();
                  return SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: allBadges.map((badge) {
                        final earned = earnedKeys.contains(badge.key);
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Tooltip(
                            message: badge.description,
                            child: Chip(
                              avatar: Icon(
                                _badgeIcon(badge.iconName),
                                color: earned ? Colors.amber : Colors.grey,
                              ),
                              label: Text(badge.title,
                                  style: TextStyle(
                                      color: earned ? null : Colors.grey)),
                              backgroundColor: earned
                                  ? Colors.amber.withOpacity(0.15)
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // ── Lessons completed ───────────────────────────────────
            Text(AppStrings.lessonsCompleted,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            progressAsync.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(message: e.toString()),
              data: (progress) {
                final completed = progress
                    .where((p) => p.isCompleted)
                    .toList();
                if (completed.isEmpty) {
                  return const Text('No lessons completed yet.');
                }
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatBox(
                            label: AppStrings.completed,
                            value: '${completed.length}',
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatBox(
                            label: 'Total',
                            value: '${progress.length}',
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Recent Activity',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...completed.reversed.take(10).map((p) => ListTile(
                          leading: const Icon(Icons.check_circle,
                              color: Colors.green),
                          title: Text(p.lessonId,
                              style: const TextStyle(fontSize: 13)),
                          subtitle: p.completedAt != null
                              ? Text(
                                  _formatDate(p.completedAt!),
                                  style: const TextStyle(fontSize: 11),
                                )
                              : null,
                          dense: true,
                        )),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}

class _StreakCard extends StatelessWidget {
  final int current;
  final int longest;
  const _StreakCard({required this.current, required this.longest});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade400, Colors.orange.shade300],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department,
              color: Colors.white, size: 44),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$current ${AppStrings.days}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
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
                      fontSize: 22,
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

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatBox(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
