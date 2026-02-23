import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_mentor/core/constants/strings.dart';
import 'package:code_mentor/core/widgets/loading_widget.dart';
import 'package:code_mentor/features/quiz/controllers/quiz_controller.dart';

class QuizScreen extends ConsumerWidget {
  final String moduleId;
  const QuizScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizControllerProvider(moduleId));
    final ctrl = ref.read(quizControllerProvider(moduleId).notifier);

    if (state.isLoading) {
      return const Scaffold(body: LoadingWidget());
    }

    if (state.submitted) {
      return _QuizResultsScreen(moduleId: moduleId);
    }

    if (state.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.quiz)),
        body: const Center(child: Text('No checkpoint questions available.')),
      );
    }

    final total = state.questions.length;
    final idx = state.currentIndex;
    final question = state.questions[idx];
    final currentAnswer = state.answers[question.id];
    final isLast = idx == total - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.quiz),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
                child: Text('${idx + 1} / $total',
                    style: const TextStyle(fontWeight: FontWeight.bold))),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: (idx + 1) / total),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.questionOf
                        .replaceFirst('{current}', '${idx + 1}')
                        .replaceFirst('{total}', '$total'),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(question.prompt,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  if (question.type == 'multiple_choice')
                    _QuizMultipleChoice(
                      options: (question.data['options'] as List<dynamic>?)
                              ?.cast<String>() ??
                          [],
                      selected: currentAnswer,
                      onSelect: (i) =>
                          ctrl.answerQuestion(question.id, i.toString()),
                    )
                  else
                    _QuizTextInput(
                      initial: currentAnswer ?? '',
                      onChanged: (v) => ctrl.answerQuestion(question.id, v),
                    ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (idx > 0)
                    OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Prev'),
                      onPressed: () => ctrl.goToQuestion(idx - 1),
                    ),
                  const Spacer(),
                  if (!isLast)
                    FilledButton.icon(
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text(AppStrings.nextQuestion),
                      onPressed: () => ctrl.goToQuestion(idx + 1),
                    )
                  else
                    FilledButton(
                      onPressed: () => ctrl.submitQuiz(),
                      child: const Text(AppStrings.submitQuiz),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizMultipleChoice extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final void Function(int) onSelect;
  const _QuizMultipleChoice(
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
            child: Text('${labels[i]}. ${options[i]}'),
          ),
        );
      }),
    );
  }
}

class _QuizTextInput extends StatefulWidget {
  final String initial;
  final void Function(String) onChanged;
  const _QuizTextInput(
      {required this.initial, required this.onChanged});

  @override
  State<_QuizTextInput> createState() => _QuizTextInputState();
}

class _QuizTextInputState extends State<_QuizTextInput> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      decoration: const InputDecoration(
        hintText: AppStrings.yourAnswer,
        border: OutlineInputBorder(),
        filled: true,
      ),
      onChanged: widget.onChanged,
    );
  }
}

// ── Results screen ──────────────────────────────────────────────────────────

class _QuizResultsScreen extends ConsumerWidget {
  final String moduleId;
  const _QuizResultsScreen({required this.moduleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizControllerProvider(moduleId));
    final ctrl = ref.read(quizControllerProvider(moduleId).notifier);
    final theme = Theme.of(context);
    final passed = state.passed ?? false;
    final score = state.score ?? 0;
    final total = state.questions.length;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.quizResults)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              passed ? Icons.emoji_events : Icons.restart_alt,
              size: 72,
              color: passed ? Colors.amber : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              passed ? AppStrings.quizPassed : AppStrings.quizFailed,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '$score / $total ${AppStrings.quizScore}',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text('Answer Review',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...state.questions.asMap().entries.map((entry) {
              final q = entry.value;
              final userAnswer = state.answers[q.id] ?? '';
              final correct = _isCorrect(q, userAnswer);
              return _AnswerReviewTile(
                index: entry.key,
                prompt: q.prompt,
                userAnswer: userAnswer,
                isCorrect: correct,
                correctAnswer: _correctText(q),
              );
            }).toList(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.replay),
                label: const Text(AppStrings.retakeQuiz),
                onPressed: () {
                  // Re-create controller by going back and re-entering
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to Stage'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isCorrect(dynamic q, String answer) {
    if (q.type == 'multiple_choice') {
      final idx = q.data['correct_index'] as int? ?? -1;
      return int.tryParse(answer) == idx;
    }
    return false;
  }

  String _correctText(dynamic q) {
    if (q.type == 'multiple_choice') {
      final options =
          (q.data['options'] as List<dynamic>?)?.cast<String>() ?? [];
      final idx = q.data['correct_index'] as int? ?? -1;
      if (idx >= 0 && idx < options.length) return options[idx];
    }
    final acceptable =
        (q.data['acceptable'] as List<dynamic>?)?.cast<String>() ?? [];
    return acceptable.isNotEmpty ? acceptable.first : '';
  }
}

class _AnswerReviewTile extends StatelessWidget {
  final int index;
  final String prompt;
  final String userAnswer;
  final bool isCorrect;
  final String correctAnswer;
  const _AnswerReviewTile({
    required this.index,
    required this.prompt,
    required this.userAnswer,
    required this.isCorrect,
    required this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? Colors.green : Colors.red;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isCorrect ? Icons.check_circle : Icons.cancel,
              color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Q${index + 1}: $prompt',
                    style:
                        const TextStyle(fontWeight: FontWeight.w500)),
                if (userAnswer.isNotEmpty)
                  Text('Your answer: $userAnswer',
                      style: const TextStyle(fontSize: 12)),
                if (!isCorrect && correctAnswer.isNotEmpty)
                  Text('Correct: $correctAnswer',
                      style: TextStyle(
                          fontSize: 12, color: Colors.green.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
