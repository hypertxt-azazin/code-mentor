import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_mentor/core/constants/strings.dart';
import 'package:code_mentor/core/widgets/error_widget.dart';
import 'package:code_mentor/core/widgets/loading_widget.dart';
import 'package:code_mentor/features/practice/controllers/practice_controller.dart';

class PracticeScreen extends ConsumerWidget {
  final String lessonId;
  const PracticeScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceControllerProvider(lessonId));
    final ctrl = ref.read(practiceControllerProvider(lessonId).notifier);

    if (state.isLoading) {
      return const Scaffold(body: LoadingWidget());
    }

    if (state.error != null && state.challenges.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.practice)),
        body: AppErrorWidget(message: state.error),
      );
    }

    final total = state.challenges.length;

    if (state.isDone) {
      return _SummaryScreen(lessonId: lessonId, total: total);
    }

    final current = state.current!;
    final currentNum = state.currentIndex + 1;
    final isWide = MediaQuery.of(context).size.width >= 720;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.practice),
      ),
      body: Column(
        children: [
          // Top stepper on mobile
          if (!isWide) _TopStepper(current: currentNum, total: total),
          if (state.challenges.isNotEmpty && state.remainingAttempts < 999)
            _AttemptsBar(remaining: state.remainingAttempts),
          Expanded(
            child: isWide
                // Web: left stepper + content
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LeftStepper(
                        current: currentNum,
                        total: total,
                        onTap: (i) {
                          // Allow navigating only to already-seen steps
                          if (i < state.currentIndex) {
                            // no-op – controller doesn't support back nav
                          }
                        },
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(
                        child: _DrillContent(
                          state: state,
                          ctrl: ctrl,
                          total: total,
                          current: current,
                        ),
                      ),
                    ],
                  )
                : _DrillContent(
                    state: state,
                    ctrl: ctrl,
                    total: total,
                    current: current,
                  ),
          ),
        ],
      ),
    );
  }
}

/// Top stepper shown on mobile — a labelled progress bar.
class _TopStepper extends StatelessWidget {
  final int current;
  final int total;
  const _TopStepper({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.challengeOf
                    .replaceFirst('{current}', '$current')
                    .replaceFirst('{total}', '$total'),
                style: theme.textTheme.labelMedium,
              ),
              Text('$current / $total',
                  style: theme.textTheme.labelMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: current / total,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }
}

/// Left stepper shown on web — vertical list of step indicators.
class _LeftStepper extends StatelessWidget {
  final int current;
  final int total;
  final void Function(int) onTap;
  const _LeftStepper(
      {required this.current, required this.total, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 80,
      color: theme.colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: List.generate(total, (i) {
          final stepNum = i + 1;
          final isDone = stepNum < current;
          final isActive = stepNum == current;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? theme.colorScheme.primary
                          : isDone
                              ? Colors.green
                              : theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: Center(
                      child: isDone
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 16)
                          : Text(
                              '$stepNum',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isActive
                                      ? Colors.white
                                      : theme.colorScheme.onSurface),
                            ),
                    ),
                  ),
                  if (i < total - 1)
                    Container(
                      width: 2,
                      height: 16,
                      color: isDone
                          ? Colors.green
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// The main drill content (question + answer input + feedback).
class _DrillContent extends StatelessWidget {
  final PracticeState state;
  final PracticeController ctrl;
  final int total;
  final dynamic current;
  const _DrillContent({
    required this.state,
    required this.ctrl,
    required this.total,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prompt
          Text(current.prompt,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Answer input
          if (!state.submitted) ...[
            if (current.type == 'multiple_choice')
              _MultipleChoiceInput(
                options: (current.data['options'] as List<dynamic>?)
                        ?.cast<String>() ??
                    [],
                selected: state.userAnswer,
                onSelect: (i) => ctrl.setAnswer(i.toString()),
              )
            else if (current.type == 'short_text')
              _TextInput(
                hint: AppStrings.yourAnswer,
                onChanged: ctrl.setAnswer,
              )
            else
              _TextInput(
                hint: 'Write your code here…',
                multiline: true,
                onChanged: ctrl.setAnswer,
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: state.userAnswer != null
                    ? () => ctrl.submitAnswer()
                    : null,
                child: const Text(AppStrings.submit),
              ),
            ),
          ] else ...[
            // Feedback
            _FeedbackCard(
              isCorrect: state.isCorrect ?? false,
              explanation: current.data['explanation'] as String? ?? '',
              userAnswer: state.userAnswer ?? '',
              correctAnswer: _correctAnswerText(current),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: ctrl.nextChallenge,
                child: Text(state.currentIndex + 1 < total
                    ? AppStrings.nextChallenge
                    : 'View Summary'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _correctAnswerText(dynamic challenge) {
    if (challenge.type == 'multiple_choice') {
      final options =
          (challenge.data['options'] as List<dynamic>?)?.cast<String>() ?? [];
      final idx = challenge.data['correct_index'] as int? ?? -1;
      if (idx >= 0 && idx < options.length) return options[idx];
    }
    if (challenge.type == 'short_text') {
      final acceptable =
          (challenge.data['acceptable'] as List<dynamic>?)?.cast<String>() ??
              [];
      return acceptable.isNotEmpty ? acceptable.first : '';
    }
    return challenge.data['exact_match'] as String? ?? '';
  }
}

class _AttemptsBar extends StatelessWidget {
  final int remaining;
  const _AttemptsBar({required this.remaining});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.amber.shade50,
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: Colors.amber),
          const SizedBox(width: 8),
          Text(
            AppStrings.attemptsLeft.replaceFirst('{n}', '$remaining'),
            style: const TextStyle(fontSize: 13),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Text(AppStrings.upgrade),
          ),
        ],
      ),
    );
  }
}

class _MultipleChoiceInput extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final void Function(int) onSelect;
  const _MultipleChoiceInput(
      {required this.options, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final labels = ['A', 'B', 'C', 'D'];
    return Column(
      children: List.generate(options.length, (i) {
        final isSelected = selected == i.toString();
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor,
              ),
              alignment: Alignment.centerLeft,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () => onSelect(i),
            child: Text(
              '${labels[i]}. ${options[i]}',
              style: TextStyle(
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _TextInput extends StatelessWidget {
  final String hint;
  final bool multiline;
  final void Function(String) onChanged;
  const _TextInput(
      {required this.hint, this.multiline = false, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: multiline ? 8 : 1,
      style: multiline
          ? const TextStyle(fontFamily: 'monospace')
          : null,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        filled: true,
      ),
      onChanged: onChanged,
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final bool isCorrect;
  final String explanation;
  final String userAnswer;
  final String correctAnswer;
  const _FeedbackCard(
      {required this.isCorrect,
      required this.explanation,
      required this.userAnswer,
      required this.correctAnswer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isCorrect ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isCorrect ? Icons.check_circle : Icons.cancel,
                  color: color),
              const SizedBox(width: 8),
              Text(
                isCorrect ? AppStrings.correct : AppStrings.incorrect,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
          if (!isCorrect && correctAnswer.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Correct answer: $correctAnswer',
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
          if (explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(explanation, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _SummaryScreen extends ConsumerWidget {
  final String lessonId;
  final int total;
  const _SummaryScreen({required this.lessonId, required this.total});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceControllerProvider(lessonId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Drills Complete')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 72),
              const SizedBox(height: 16),
              Text('You finished all $total drills!',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
