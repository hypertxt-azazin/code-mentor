import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:code_mentor/core/constants/strings.dart';
import 'package:code_mentor/core/widgets/error_widget.dart';
import 'package:code_mentor/core/widgets/loading_widget.dart';
import 'package:code_mentor/features/catalog/controllers/catalog_controller.dart';
import 'package:code_mentor/features/catalog/domain/models/module.dart';
import 'package:code_mentor/features/catalog/domain/models/track.dart';

class TrackDetailScreen extends ConsumerWidget {
  final String trackId;
  const TrackDetailScreen({super.key, required this.trackId});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final trackAsync = ref.watch(trackProvider(trackId));
    final modulesAsync = ref.watch(modulesProvider(trackId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: trackAsync.maybeWhen(
          data: (t) => Text(t?.title ?? 'Track'),
          orElse: () => const Text('Track'),
        ),
      ),
      body: trackAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.invalidate(trackProvider(trackId)),
        ),
        data: (track) {
          if (track == null) {
            return const Center(child: Text(AppStrings.notFound));
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _TrackHeader(track: track, theme: theme)),
              modulesAsync.when(
                loading: () => const SliverFillRemaining(
                    child: LoadingWidget()),
                error: (e, _) => SliverFillRemaining(
                    child: AppErrorWidget(message: e.toString())),
                data: (modules) {
                  if (modules.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text(AppStrings.noModulesFound)),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => _ModuleCard(
                          module: modules[i],
                          index: i,
                        ),
                        childCount: modules.length,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TrackHeader extends StatelessWidget {
  final Track track;
  final ThemeData theme;
  const _TrackHeader({required this.track, required this.theme});

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
    return Container(
      padding: const EdgeInsets.all(20),
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(track.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(track.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Chip(
                label: Text(
                  track.difficulty[0].toUpperCase() +
                      track.difficulty.substring(1),
                  style: TextStyle(
                    color: _difficultyColor(track.difficulty),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor:
                    _difficultyColor(track.difficulty).withOpacity(0.15),
              ),
              const SizedBox(width: 8),
              ...track.tags
                  .take(3)
                  .map((tag) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Chip(
                          label: Text(tag, style: const TextStyle(fontSize: 12)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ))
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModuleCard extends ConsumerWidget {
  final CourseModule module;
  final int index;
  const _ModuleCard({required this.module, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUnlocked =
        ref.watch(moduleUnlockProvider((module.id, module.order)));
    final lessonsAsync = ref.watch(lessonsProvider(module.id));
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isUnlocked
            ? () => context.push('/module/${module.id}')
            : () => _showUpgradeSheet(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: isUnlocked
                    ? theme.colorScheme.primaryContainer
                    : Colors.grey.shade200,
                child: isUnlocked
                    ? Text(
                        '${index + 1}',
                        style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer),
                      )
                    : const Icon(Icons.lock, size: 18, color: Colors.grey),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(module.title,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      module.description.length > 80
                          ? '${module.description.substring(0, 80)}…'
                          : module.description,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    lessonsAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (lessons) => Text(
                        '${lessons.length} lessons',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isUnlocked)
                const Icon(Icons.lock_outline, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpgradeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock, size: 48, color: Colors.amber),
            const SizedBox(height: 16),
            const Text(AppStrings.upgradeToUnlock,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text(AppStrings.unlockAllTracks,
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/premium');
              },
              child: const Text(AppStrings.upgrade),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.dismiss),
            ),
          ],
        ),
      ),
    );
  }
}
