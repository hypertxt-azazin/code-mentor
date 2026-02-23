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

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sections.length,
                  itemBuilder: (context, i) {
                    final section =
                        sections[i] as Map<String, dynamic>? ?? {};
                    final type = section['type'] as String? ?? 'paragraph';
                    final content = section['content'] as String? ?? '';
                    return _SectionWidget(type: type, content: content);
                  },
                ),
              ),
              _LessonBottomBar(
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
              ),
            ],
          );
        },
      ),
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
