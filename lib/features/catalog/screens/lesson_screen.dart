import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:code_mentor/app/providers.dart';
import 'package:code_mentor/core/constants/strings.dart';
import 'package:code_mentor/core/widgets/error_widget.dart';
import 'package:code_mentor/core/widgets/loading_widget.dart';
import 'package:code_mentor/features/catalog/controllers/catalog_controller.dart';
import 'package:code_mentor/features/lesson/controllers/lesson_controller.dart';

class LessonScreen extends ConsumerWidget {
  final String lessonId;
  const LessonScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonAsync = ref.watch(lessonProvider(lessonId));
    final isCompleted = ref.watch(lessonCompletionProvider(lessonId));
    final profile = ref.watch(currentUserProfileProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: lessonAsync.maybeWhen(
          data: (l) => Text(l?.title ?? AppStrings.lesson),
          orElse: () => const Text(AppStrings.lesson),
        ),
        actions: [
          if (isCompleted)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.check_circle, color: Colors.green),
            ),
        ],
      ),
      body: lessonAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(message: e.toString()),
        data: (lesson) {
          if (lesson == null) {
            return const Center(child: Text(AppStrings.notFound));
          }

          final sections = lesson.content['sections'] as List<dynamic>? ?? [];

          // Collect key takeaways from 'heading' or 'key_takeaway' sections
          final takeaways = sections
              .whereType<Map<String, dynamic>>()
              .where((s) =>
                  s['type'] == 'key_takeaway' || s['type'] == 'heading')
              .map((s) => s['content'] as String? ?? '')
              .where((t) => t.isNotEmpty)
              .toList();

          final isWide = MediaQuery.of(context).size.width >= 720;

          final contentList = ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sections.length,
            itemBuilder: (context, i) {
              final section =
                  sections[i] as Map<String, dynamic>? ?? {};
              final type = section['type'] as String? ?? 'paragraph';
              final content = section['content'] as String? ?? '';
              return _SectionWidget(type: type, content: content);
            },
          );

          final bottomBar = _LessonBottomBar(
            lessonId: lessonId,
            moduleId: lesson.moduleId,
            isCompleted: isCompleted,
            onComplete: profile != null
                ? () async {
                    await ref
                        .read(lessonCompletionProvider(lessonId).notifier)
                        .markComplete(profile.id);
                  }
                : null,
          );

          if (isWide) {
            // Web layout: content + Key Takeaways side panel
            return Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: contentList),
                      VerticalDivider(width: 1, color: theme.dividerColor),
                      SizedBox(
                        width: 260,
                        child: _KeyTakeawaysPanel(takeaways: takeaways),
                      ),
                    ],
                  ),
                ),
                bottomBar,
              ],
            );
          }

          // Mobile layout: content + collapsible key takeaways
          return Column(
            children: [
              if (takeaways.isNotEmpty)
                _KeyTakeawaysCollapsible(takeaways: takeaways),
              Expanded(child: contentList),
              bottomBar,
            ],
          );
        },
      ),
    );
  }
}

/// Side panel for web showing key takeaways.
class _KeyTakeawaysPanel extends StatelessWidget {
  final List<String> takeaways;
  const _KeyTakeawaysPanel({required this.takeaways});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  color: theme.colorScheme.primary, size: 18),
              const SizedBox(width: 6),
              Text(AppStrings.keyTakeaways,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          if (takeaways.isEmpty)
            Text('No key takeaways yet.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.secondary))
          else
            ...takeaways.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 14,
                          color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(t,
                            style: theme.textTheme.bodySmall),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}

/// Collapsible key takeaways for mobile.
class _KeyTakeawaysCollapsible extends StatelessWidget {
  final List<String> takeaways;
  const _KeyTakeawaysCollapsible({required this.takeaways});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ExpansionTile(
      leading: Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary),
      title: Text(AppStrings.keyTakeaways,
          style: theme.textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.bold)),
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      collapsedBackgroundColor: theme.colorScheme.surfaceContainerLow,
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      children: takeaways
          .map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 14,
                        color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Expanded(child: Text(t, style: theme.textTheme.bodySmall)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _SectionWidget extends StatelessWidget {
  final String type;
  final String content;
  const _SectionWidget({required this.type, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    switch (type) {
      case 'heading':
        return Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 8),
          child: Text(
            content,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        );
      case 'code':
        return _CodeBlock(code: content);
      case 'image':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
                child: Icon(Icons.image, size: 48, color: Colors.grey)),
          ),
        );
      case 'key_takeaway':
        // Render inline as a highlighted callout
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.35),
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(
                  color: theme.colorScheme.primary, width: 3),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  color: theme.colorScheme.primary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(content, style: theme.textTheme.bodyMedium),
              ),
            ],
          ),
        );
      default: // paragraph
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(content, style: theme.textTheme.bodyMedium),
        );
    }
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;
  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12, top: 8),
                child: Text('code',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.grey, size: 18),
                tooltip: 'Copy',
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: code)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: Text(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Color(0xFFD4D4D4),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonBottomBar extends ConsumerWidget {
  final String lessonId;
  final String moduleId;
  final bool isCompleted;
  final VoidCallback? onComplete;
  const _LessonBottomBar({
    required this.lessonId,
    required this.moduleId,
    required this.isCompleted,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsProvider(moduleId));

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        child: lessonsAsync.when(
          loading: () => const SizedBox(height: 48),
          error: (_, __) => const SizedBox(height: 48),
          data: (lessons) {
            final idx = lessons.indexWhere((l) => l.id == lessonId);
            final hasPrev = idx > 0;
            final hasNext = idx >= 0 && idx < lessons.length - 1;

            return Row(
              children: [
                if (hasPrev)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text('Prev'),
                    onPressed: () {
                      context.pushReplacement(
                          '/lesson/${lessons[idx - 1].id}');
                    },
                  ),
                const Spacer(),
                if (!isCompleted)
                  FilledButton.icon(
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Mark Complete'),
                    onPressed: onComplete,
                  )
                else
                  const Row(children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 6),
                    Text('Completed',
                        style: TextStyle(color: Colors.green)),
                  ]),
                const SizedBox(width: 8),
                if (hasNext)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('Next'),
                    onPressed: () {
                      context.pushReplacement(
                          '/lesson/${lessons[idx + 1].id}');
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
