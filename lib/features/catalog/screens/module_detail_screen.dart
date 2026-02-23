import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:code_mentor/app/providers.dart';
import 'package:code_mentor/core/constants/strings.dart';
import 'package:code_mentor/core/widgets/error_widget.dart';
import 'package:code_mentor/core/widgets/loading_widget.dart';
import 'package:code_mentor/features/catalog/controllers/catalog_controller.dart';
import 'package:code_mentor/features/catalog/domain/models/lesson.dart';
import 'package:code_mentor/features/progress/controllers/progress_controller.dart';

class ModuleDetailScreen extends ConsumerWidget {
  final String moduleId;
  const ModuleDetailScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moduleAsync = ref.watch(moduleProvider(moduleId));
    final lessonsAsync = ref.watch(lessonsProvider(moduleId));
    final profile = ref.watch(currentUserProfileProvider);
    final theme = Theme.of(context);

    // Load lesson progress only when signed in
    final completedIds = profile != null
        ? ref.watch(lessonProgressProvider(profile.id)).maybeWhen(
            data: (p) => p
                .where((lp) => lp.isCompleted)
                .map((lp) => lp.lessonId)
                .toSet(),
            orElse: () => <String>{})
        : <String>{};

    return Scaffold(
      appBar: AppBar(
        title: moduleAsync.maybeWhen(
          data: (m) => Text(m?.title ?? 'Module'),
          orElse: () => const Text('Module'),
        ),
      ),
      body: moduleAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) =>
            AppErrorWidget(message: e.toString()),
        data: (module) {
          if (module == null) {
            return const Center(child: Text(AppStrings.notFound));
          }
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(module.description,
                        style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(
                      '${AppStrings.passThreshold}: ${module.passPercent}%',
                      style: theme.textTheme.labelMedium
                          ?.copyWith(color: theme.colorScheme.primary),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: lessonsAsync.when(
                  loading: () => const LoadingWidget(),
                  error: (e, _) =>
                      AppErrorWidget(message: e.toString()),
                  data: (lessons) {
                    if (lessons.isEmpty) {
                      return const Center(
                          child: Text(AppStrings.noLessonsFound));
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: lessons.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final lesson = lessons[i];
                        final done = completedIds.contains(lesson.id);
                        return _LessonTile(
                          lesson: lesson,
                          index: i,
                          isCompleted: done,
                        );
                      },
                    );
                  },
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.quiz),
                      label: const Text(AppStrings.startQuiz),
                      onPressed: () => context.push('/quiz/$moduleId'),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final Lesson lesson;
  final int index;
  final bool isCompleted;
  const _LessonTile(
      {required this.lesson,
      required this.index,
      required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: theme.dividerColor)),
      leading: CircleAvatar(
        backgroundColor: isCompleted
            ? Colors.green.withOpacity(0.15)
            : theme.colorScheme.primaryContainer,
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.green, size: 18)
            : Text(
                '${index + 1}',
                style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer),
              ),
      ),
      title: Text(lesson.title,
          style:
              const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
          '${lesson.estimatedMinutes} ${AppStrings.minutes}',
          style: theme.textTheme.labelSmall),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('/lesson/${lesson.id}'),
    );
  }
}
